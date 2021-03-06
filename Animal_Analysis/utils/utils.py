import os
from collections import Counter
from termcolor import cprint
import colorama
import json
colorama.init()
from sklearn import datasets
import matplotlib.pyplot as plt
import seaborn as sns
import time
import requests
import seaborn as sns
import pandas as pd
import numpy as np
import geopandas as gpd
from DBCV import DBCV

from scipy.interpolate import LinearNDInterpolator
from scipy import interpolate
import matplotlib.pyplot as plt
import matplotlib.cm as cm

from pyproj import CRS
from shapely.geometry import Point
from shapely.geometry import Polygon
from shapely.geometry import MultiPoint
from meteostat import Stations, Hourly
from requests.structures import CaseInsensitiveDict
from OSMPythonTools.overpass import overpassQueryBuilder, Overpass

from sklearn.cluster import DBSCAN, KMeans, OPTICS, cluster_optics_dbscan, AgglomerativeClustering
from sklearn.preprocessing import StandardScaler
import hdbscan
from sklearn.metrics import pairwise_distances
from sklearn import metrics
from scipy.spatial.distance import euclidean

def load_movebank_data(movebank_root, study_name, epsg=3395):
    """Loads in data from the movebank folder, with the specified folder structure.

    Args:
        movebank_root (str): fp to the movebank folder.
        study_name (str): full name of the study folder to load from.
        epsg (int, optional): EPSG id of the desired projection. Defaults to 3395.

    Returns:
        Tuple: The first element is the data as a GeoDataFrame, the second is the reference data as a DataFrame.
    """

    # Default epsg:3395 (Mercator)
    
    # Define parts of filepaths
    root_folder = movebank_root
    study_data = study_name + ".csv"
    reference_data = study_name + "-reference-data.csv"
    
    
    # build filepaths
    study_fp = os.path.join(root_folder, study_name, study_data)
    reference_fp = os.path.join(root_folder, study_name, reference_data)

    
    # load data
    study_df = pd.read_csv(study_fp)
    reference_df = pd.read_csv(reference_fp)
    
    # Create shapely Points
    study_df["geometry"] = study_df.apply(lambda row: Point([row["location-long"], row["location-lat"]]), axis=1)
    
    # Create gdf and assign CRS
    study_gdf = gpd.GeoDataFrame(study_df, geometry="geometry")
    study_gdf.crs = CRS(f"epsg:{epsg}").to_wkt()
    
    # cast timestamp to dt
    study_gdf["timestamp"] = pd.to_datetime(study_gdf["timestamp"], format="%Y-%m-%d %H:%M:%S.%f")
    
    cprint(f"Data shape: {study_gdf.shape}", "magenta")
    
    return study_gdf, reference_df


def get_station_temps(elephant_data, num_stations=20, fuzzy=True, verbose=True):
    """
    Get historical temperature data for all data points from a local weather station.
    
    Parameters
    ------------
    elephant_data: (DataFrame) Contains at least the following columns: ["location-lat", "location-long", "timestamp"]
    num_stations: (int) The number of stations to search through. Default 10.
    fuzzy: (bool) Use fuzzy timestamp matching. Highly recommended. Default True
    
    Returns
    ------------
    heat_joined: (DataFrame) The original elephant_data with a new stationTemp column. None if 0 stations.
    closest_station: (DataFrame) Metadata describing the weather station that the temperature data came from (from the meteostat package. None if not stations found.
    extra: (DataFrame) Some values used throughouth the calculations that may be of interest. The values are:
    
        lat: The median latitude of elephant_data, used to find the nearest weather station
        long: The median longitude of elephant_data, used to find the nearest weather station 
        start: The earliest date in elephant_data, used to narrow down the possible stations
        end: The latest date in elephant_data, used to narrow down the possible stations
        distance: The euclidean distance between the coords of the median of elephant_data, and the weather station coords. -1 if no stations.
    
    """
    

    lat = elephant_data["location-lat"].median() # take median to avoid outliers
    long = elephant_data["location-long"].median() # take median to avoid outliers
    start = elephant_data.timestamp.min().to_pydatetime()
    end = elephant_data.timestamp.max().to_pydatetime()
    
    # Get nearby weather stations
    stations = Stations()
    stations_query = stations.nearby(lat, long)
    stations = stations_query.fetch(10) #num_stations)

    # Filter to stations with data in the timeframe
    stations = stations[stations["hourly_start"].notnull()]
    possible_stations = stations[(stations["hourly_start"] <= start) & (stations["hourly_end"] >= end)]
    
    # calculate distance to study for each station
    get_distance = lambda row: Point(row.longitude, row.latitude).distance(Point(long, lat))
    possible_stations["distance"] = possible_stations.apply(get_distance, axis=1)
    
    # find closest station with data
    possible_stations.sort_values("distance", ascending = False, inplace=True) # sort by distance
    
    closest_station = None
    for _, station in possible_stations.iterrows():
        wmo = station.wmo
        query = Hourly(wmo, start, end, model=False) # build query
        query = query.normalize()
        query = query.interpolate() # fill in gaps in data
        station_data = query.fetch() # the actual API call
        if station_data.shape[0] > 0:
            closest_station = station_data
            closest_distance = station.distance
            if verbose:
                print(f"Using station data from Station(wmo = {station.wmo}) at distance {round(closest_distance, 3)}")
            break
    
    if closest_station is None:
        if verbose:
            print("No stations found")
        heat_joined = None
        closest_distance = -1
        closest_station = None
    else:
        wmo_heat = closest_station[["temp"]]
        tol = elephant_data.timestamp.diff().median() / 2
        
        # pd.merge_asof requires sorting beforehand
        elephant_data.sort_values("timestamp", inplace=True)
        wmo_heat.sort_index(inplace=True)
        
        if fuzzy:
            if verbose:
                print(f"Fuzzy tolerance: {tol}")
            heat_joined = pd.merge_asof(right=wmo_heat, left=elephant_data, right_index=True, left_on="timestamp", tolerance=tol, direction="forward").reset_index(drop=True)
        else:
            heat_joined = pd.merge(left=elephant_data, right=wmo_heat, left_on="timestamp", right_index=True, how="left").reset_index(drop=True)
        
        heat_joined.rename(columns={"temp": "stationTemp"}, inplace=True)
        if heat_joined[heat_joined.stationTemp.notna()].shape[0] == 0:
            if verbose:
                print("No timestamps found")
            heat_joined = None
        
    extra = {"lat": lat, "long": long, "start": start, "end": end, "distance": closest_distance}
    #print(heat_joined)
    #print("Elevation Test")
    heat_joined.to_csv("zeb.csv")
    heat_joined =  elevationFeature(heat_joined)
    #heat_joined.to_csv("AG004.csv")
    #print(heat_joined)
    return heat_joined, closest_station, pd.DataFrame(extra, index=[0])
    

def stationGradientBuilder(xlat, ylong, z, newXLat, newYLong):
    
    '''
    xlat - array with latitudes in sorted order of stations distance from elephant data
    ylong - array with longitudes in sorted order of stations distance from elephant data
    z - array with tempatures at the timestamp the stations in sorted order of stations distance from elephant data
    newXLat - array of latitudes to find tampature at
    newYLong - array of longitudes to find tempature at
    newZ - new tempatures produced by gradient function
    '''
    #f = interpolate.interp2d(xlat, ylong, z, kind='linear')
    #newZ = f(newXLat, newYLong)
    interp = LinearNDInterpolator(list(zip(xlat, ylong)), z)
    newZ = interp(newXLat, newYLong)
    
    #plotting the gradient
    '''
    X = np.linspace(min(xlat), max(xlat))
    Y = np.linspace(min(ylong), max(ylong))
    X, Y = np.meshgrid(X, Y)
    Z = interp(X, Y)
    plt.pcolormesh(X, Y, Z, shading='auto')
    plt.plot(xlat, ylong, "ok", label="input point")
    plt.legend()
    plt.colorbar()
    plt.axis("equal")
    plt.show()
    '''
    return newZ
    


def elevationFeature(table):
    
    if table is None:
        return None
        
    allElevation = []
    locations = []
    list = []
    lats = table[['location-lat']].values
    longs = table[['location-long']].values
    lats = [float(x) for [x] in lats]
    longs = [float(x) for [x] in longs]
    
    keys = ["latitude", "longitude"]
    
    for j in range(len(lats)):
        inter = {}
        for i in keys:
            inter[i] = lats[j]
            inter[i] = longs[j]
        locations.append(inter)
    ll = len(lats) // 4
    a = elevationAPIcall(locations[:ll])
    b = elevationAPIcall(locations[ll:(2*ll)])
    c = elevationAPIcall(locations[(2*ll):(3*ll)])
    d = elevationAPIcall(locations[(3*ll):])
    
    if a == None:
        return None
    
    all = [a,b,c,d]
    new = []
    for i in all:
        temp = i.text
        temp = json.loads(temp)
        new.append(temp['results'])
        
    for j in range(4):
        for i in range(len(new[j])):
            allElevation.append(new[j][i]['elevation'])
        
    table['elevation'] = allElevation

    return table
    
    
def elevationAPIcall(locations):

    dict = {}
    dict["locations"] = locations
    url = "https://api.open-elevation.com/api/v1/lookup"

    headers = CaseInsensitiveDict()
    headers["Accept"] = "application/json"
    headers["Content-Type"] = "application/json"

    data = json.dumps(dict)
    resp = requests.post(url, headers=headers, data=data)
    #print(resp.status_code)
    
    if resp.status_code != 200:
        resp = None
    
    return resp
    
def nearbyWaterBodies():

    polys = gpd.read_file("/Users/h1n3z/Desktop/ElephantsDBSCANResearch-main/utils/africawaterbody/Africa_waterbody.shp")
    #print(polys[['geometry']])
   
    col = polys.columns.tolist()
    nodes = []
    # Extraction of the polygon nodes and attributes values from polys and integration into the new GeoDataFrame
    for index, row in polys.iterrows():
        for j in list(row['geometry'].exterior.coords):
            nodes.append([int(row['AF_WTR_ID']), row['NAME_OF_WA'], row['TYPE_OF_WA'], Point(j)])
            
    newDf = pd.DataFrame(nodes, columns=['AF_WTR_ID', 'NAME_OF_WA', 'TYPE_OF_WA', 'geometry'])

    #Plotting
    '''
    ig, ax = plt.subplots(figsize = (10,10))
    polys.plot(ax=ax)
    plt.show()
    '''
    return newDf



def perform_DBSCAN(data, radius, min_points, noise, cols):

    subset = data[cols]
    scaled = StandardScaler().fit_transform(subset)

    # perform DBSCAN 
    db = DBSCAN(eps=radius, min_samples=min_points).fit(scaled)
    
    # add cluster labels
    labels = db.labels_
    data["cluster"] = labels
    
    
    try:
        print("DBSCAN S_SCORE:", metrics.silhouette_score(scaled, labels, metric='euclidean'))
    except:
        pass
    try:
        print("DBSCAN CH_SCORE:", metrics.calinski_harabasz_score(scaled, labels))
    except:
        pass
    
    if not noise:
        return data[data["cluster"] != -1]

    return data


def perform_OPTICS(data, noise, cols, r=0.5):
    subset = data[cols]

    # run OPTICS
    clust = OPTICS()
    clust.fit(subset)
    labels = cluster_optics_dbscan(reachability=clust.reachability_,
                                core_distances=clust.core_distances_,
                                ordering=clust.ordering_, eps=r)
    # labels = clust.labels_[clust.ordering_]

    # add cluster labels
    data["cluster"] = labels
    
    if not noise:
        return data[data["cluster"] != -1]

    return data
    
    
    
    
def perform_HDBSCAN(data, noise, cols, r=0.6):
    
    subset = data[cols]
    scaled = StandardScaler().fit_transform(subset)
    
    #Run HDBSCAN
    clusterer = hdbscan.HDBSCAN(min_cluster_size=80,
                                cluster_selection_epsilon=r,
                                cluster_selection_method = 'eom',
                                gen_min_span_tree=True)
    clusterer.fit(scaled)
    

    
    labels = clusterer.labels_
    # add cluster labels
    data["cluster"] = labels
    
    try:
        print("HDBSCAN S_SCORE:", metrics.silhouette_score(scaled, labels, metric='euclidean'))
    except:
        pass
    try:
        print("HDBSCAN CH_SCORE:", metrics.calinski_harabasz_score(scaled, labels))
    except:
        pass
   
    #print("HDBSCAN DBCV_SCORE:", DBCV(scaled, labels, dist_function=euclidean))
    
    
    if not noise:
        return data[data["cluster"] != -1]

    return data




def perform_AGGLO(data, noise, cols):

    subset = data[cols]
    scaled = StandardScaler().fit_transform(subset)
    
    clusterer = AgglomerativeClustering(n_clusters=6)
    clusterer.fit(scaled)
    
    labels = clusterer.labels_
    # add cluster labels
    data["cluster"] = labels
    
    if not noise:
        return data[data["cluster"] != -1]

    return data




def get_clusters(data, cols, method, r, mp, noise=False):
    """Calls clustering method and calculates centroids

    Args:
        data (DataFrame): The data to cluster on.
        cols (list): The feature space used to calculate clusters.
        method (str): The clustering method to use (Options include ["DBSCAN", "OPTICS"]).
        r (float, optional): Radius for DBSCAN. Defaults to 0.2.
        mp (int, optional): MinPoints (epsilon) for DBSCAN. Defaults to 50.
        noise (bool, optional): Return points in the noise cluster (-1 label). Defaults to False.

    Returns:
        (clusters, centroids): Tuple containing the clusters and centroids DataFrame and GeoDataFrame, respectively.
    """


    if method == "DBSCAN":
        clusters = perform_DBSCAN(data, 
                                radius=r, 
                                min_points=mp,
                                noise=noise,
                                cols=cols
                                )
    elif method == "OPTICS":
        clusters = perform_OPTICS(data, noise=noise, cols=cols, r=r)
        
    elif method == "HDBSCAN":
        clusters = perform_HDBSCAN(data, noise=noise, cols=cols, r=r)
        
    elif method == "AGGLO":
        clusters = perform_AGGLO(data, noise=noise, cols=cols)

    # calculate centroids
    grouped = clusters.groupby("cluster")
    centroids = grouped[cols].apply(np.mean)
    centroids.index.name = "index"
    centroids["cluster"] = centroids.index
    centroids["geometry"] = centroids.apply(lambda row: Point([row["location-long"], row["location-lat"]]), axis=1)

    
    return clusters, centroids


def with_and_without_heat(data,
                        method,
                        heat_col="stationTemp",
                        ele_col="elevation",
                        noise=True,
                        r_heat=0.2, mp_heat=50, r_wo=0.1, mp_wo=35, verbose=True):
    """Run the specified method with the Temp-Influenced and Without Temp-influence feature spaces.

    Args:
        data (GeoDataFrame): Contains the data to cluster.
        method (str): The clustering method to use (Options include ["DBSCAN", "OPTICS"]).
        heat_col (str, optional): Name of the heat column to use for the temperature feature. Defaults to "stationTemp".
        noise (bool, optional): Include noise-labeled points in the return DataFrame. Defaults to True.
        r_heat (float, optional): Radius for Temp-Influenced (DBSCAN only). Defaults to 0.2.
        mp_heat (int, optional): MinPoints for Temp-Influenced (DBSCAN only). Defaults to 50.
        r_wo (float, optional): Radius for Without Temp-influence (DBSCAN only). Defaults to 0.1.
        mp_wo (int, optional): MinPoints for Without Temp-influence (DBSCAN only). Defaults to 35.
        verbose (bool, optional): Show more info in console output. Defaults to True.

    Returns:
        list: [(clusters_heat, centroids_heat), (clusters_wo, centroids_wo)]
    """
    
    clusters_heat, centroids_heat, clusters_wo, centroids_wo = None, None, None, None
   
    
    # some data points' temp will be NaN if it couldn't be found by in station data. Drop these rows.
    data_with_temps = data[data[heat_col].notna()]
    data_with_temps = data_with_temps[data_with_temps[ele_col].notna()]
    if verbose:
        print(f"Calculating temp-influenced clusters and centroids {data_with_temps.shape}")

    clusters_heat, centroids_heat = get_clusters(data_with_temps, 
                                        ["location-long", "location-lat", heat_col, ele_col],
                                        method=method,
                                        r=r_heat, mp=mp_heat, 
                                        noise=noise
                                        )
    centroids_heat["feature space"] = "Temp-influenced"

    if verbose:
        print(f"Calculating without-temp clusters and centroids {data.shape}")
    # use all data, regardless of missing temp to calculate exclusively coordinate-based clustering
    clusters_wo, centroids_wo = get_clusters(data, 
                                        ["location-long", "location-lat"],
                                        method=method,
                                        r=r_wo, mp=mp_wo, 
                                        noise=noise
                                        )
    centroids_wo["feature space"] = "Without temp-influence"
    
    
    
        
    
    return [(clusters_heat, centroids_heat), (clusters_wo, centroids_wo)]


def run_algorithm(data, fuzzy=True, r_heat=0.2, mp_heat=50, r_wo=0.1, mp_wo=35, verbose=True, clustering_method="DBSCAN"):
    """
    The most comprehensive form of the DBSCAN algorithm with appended historical weather station data. This function will
    run DBSCAN on the given data, as well as calculate temperature from weather stations. 
    
    Parameters
    -----------
    
    data: (DataFrame) Contains at least the columns ["location-lat", "location-long", "timestamp", "tag-local-identifier"].
    fuzzy: (bool, optional) Toggle fuzzy matching, as described in the research paper. Default True.
    verbose: (bool, optional) Print more stuff. Default True.
    clustering_method: (str, optional) The clustering method to use (Options include ["DBSCAN", "OPTICS"])
    
    
    Returns
    -----------
    centroids: (DataFrame) The centroids calculated (mean of values in given cluster). This is both Temp-Influenced and Without Temp-Influence.
    clusters: (DataFrame) The clusters calculated. This is only Without Temp-Influence, as the Temp-Influenced clusters are not too useful to visualize.
    percents_found: (list) List of percents of timestamps matched for each unique tag-local-identifier (in the order of data["tag-local-identifier"].unique())
    """

    centroids = None
    clusters = None
    
    all_centroids = []
    all_clusters = []
    percents_found = []

    for id, group, in data.groupby("tag-local-identifier"):
        cprint(f"Processing id: {id}", "magenta")

        station_data, station, extra = get_station_temps(group, fuzzy=fuzzy, verbose=verbose)
            

        # move in if no stations were found
        if station_data is None:
            if verbose:
                print("\n")
            continue

        station_data.to_csv("AG00"+id+".csv")
        # calculate percent of timestamps we found temp data for
        percent_found = station_data[station_data["stationTemp"].notna()].shape[0] / group.shape[0] * 100
        if verbose:
            print("Timestamps found: ", str(round(percent_found, 3)) + "%") 
        percents_found.append(percent_found)

        # etosha values
        # r_heat=0.2, mp_heat=25, 
        # r_wo=0.06, mp_wo=45
        
        (clusters_heat, centroids_heat), (clusters_wo, centroids_wo)  =  with_and_without_heat(station_data,
                                                                                            method=clustering_method,
                                                                                            r_heat=r_heat, mp_heat=mp_heat, 
                                                                                            r_wo=r_wo, mp_wo=mp_wo,
                                                                                            verbose=verbose
                                                                                            )
        
        
                #### Normally centroids_heat
        centroids = centroids_heat.append(centroids_wo)
        
        if verbose:
            print(f"Temp-Influenced centroids: {centroids_heat.shape[0]}")
            print(f"Without Temp-Influenced centroids: {centroids_wo.shape[0]}")
            print("\n")

        centroids["tag-local-identifier"] = id
        
        all_centroids.append(centroids)
        all_clusters.append(clusters_wo)
        
    if all_centroids != []:
        centroids = pd.concat(all_centroids, ignore_index=True)
    if all_clusters != []:
        clusters = pd.concat(all_clusters, ignore_index=True)
        
    cprint(f"Number of clusters: {clusters.shape[0]}", "magenta")
    cprint(f"Number of centroids: {centroids.shape[0]}", "magenta")
        
    return centroids, clusters, percents_found



def get_nearby_settlements(centroids, radius=1):


    print("getting human settlements")

    center_lat = centroids["location-lat"].median()
    center_long= centroids["location-long"].median()

    overpass = Overpass()

    ## bbox to get places in 
    bbox=[center_lat-radius, center_long-radius, center_lat+radius,center_long+radius]

    query = overpassQueryBuilder(
        bbox=bbox,
        elementType='node', 
        selector='place~"city|town|village|hamlet"',
        out='body'
    )

    res = overpass.query(query, timeout=50)

    places = pd.DataFrame(res.toJSON()['elements'])
    places = places.drop('tags', axis=1).join(pd.DataFrame(places.tags.values.tolist()))
    places["geometry"] = places.apply(lambda row: Point([row["lon"], row["lat"]]), axis=1)
    places = gpd.GeoDataFrame(places, geometry="geometry")
    
    places.to_csv('places.csv')
    
    
    return places


def get_top_n_places(centroids, places, n=10):

    cprint(f"Number of places: {places.shape[0]}", "magenta")

    if places.shape[0] > centroids.shape[0]:
        num_clusters = int(round(centroids.shape[0] * .75, 0))
        cprint(f"WARNING: Sampling down to {num_clusters} places, as there are more places than elephant centroids", "red")
        places = places.sample(n=num_clusters, random_state=42, replace=False)

    c_points = np.array(centroids.geometry.apply(lambda p: [p.x, p.y]).tolist())
    
    p_points = np.array(places.geometry.apply(lambda p: [p.x, p.y]).tolist())
    

    # use KMeans to identify how many centroids are near each settlement
    kmeans = KMeans(n_clusters=places.shape[0], init=p_points, max_iter=1)
    kmeans.fit(c_points)

    # Find Top 10 settlements based on cluster size
    counted = Counter(kmeans.labels_)
    n_counted = counted.most_common(n)
    idxs = [k for k, v in n_counted]
    top_n_places = places.iloc[idxs]
    top_n_places["n_centroids_in_settlement_cluster"] = [v for k, v in n_counted]

    
    # subset columns
    cols = ["geometry", "name", "place", "old_name", "alt_name", "n_centroids_in_settlement_cluster"]
    if "description" in top_n_places.columns:
            cols.insert(0, "description")
    try:
        top_n_places = top_n_places[cols]
    except:
        print("INVALID columns. Valid columns are:", top_n_places.columns)

    return top_n_places

                            
def with_and_without_ele(data,
                    method,
                    ele_col="elevation",
                    noise=True,
                    r_heat=0.2, mp_heat=50, r_wo=0.1, mp_wo=35, verbose=True):
    """Run the specified method with the Temp-Influenced and Without Temp-influence feature spaces.

    Args:
        data (GeoDataFrame): Contains the data to cluster.
        method (str): The clustering method to use (Options include ["DBSCAN", "OPTICS"]).
        heat_col (str, optional): Name of the heat column to use for the temperature feature. Defaults to "stationTemp".
        noise (bool, optional): Include noise-labeled points in the return DataFrame. Defaults to True.
        r_heat (float, optional): Radius for Temp-Influenced (DBSCAN only). Defaults to 0.2.
        mp_heat (int, optional): MinPoints for Temp-Influenced (DBSCAN only). Defaults to 50.
        r_wo (float, optional): Radius for Without Temp-influence (DBSCAN only). Defaults to 0.1.
        mp_wo (int, optional): MinPoints for Without Temp-influence (DBSCAN only). Defaults to 35.
        verbose (bool, optional): Show more info in console output. Defaults to True.

    Returns:
        list: [(clusters_heat, centroids_heat), (clusters_wo, centroids_wo)]
    """

    clusters_ele, cluster_ele, clusters_wo, centroids_wo = None, None,None, None

    # some data points' temp will be NaN if it couldn't be found by in station data. Drop these rows.
    data_with_eles = data[data[ele_col].notna()]
    #Elevation
    if verbose:
        print(f"Calculating elevation clusters and centroids {data_with_eles.shape}")
    clusters_ele, centroids_ele = get_clusters(data_with_eles,
                                        ["location-long", "location-lat", ele_col],
                                        method=method,
                                        r=r_wo, mp=mp_wo,
                                        noise=noise
                                        )
    centroids_ele["feature space"] = "Elevation-Influenced"


    if verbose:
        print(f"Calculating without-elevation clusters and centroids {data.shape}")
    # use all data, regardless of missing temp to calculate exclusively coordinate-based clustering
    clusters_wo, centroids_wo = get_clusters(data,
                                        ["location-long", "location-lat"],
                                        method=method,
                                        r=r_wo, mp=mp_wo,
                                        noise=noise
                                        )
    centroids_wo["feature space"] = "Without elevation"


        

    return [(clusters_ele, centroids_ele), (clusters_wo, centroids_wo)]



def run_algorithm2(data, fuzzy=True, r_heat=0.2, mp_heat=50, r_wo=0.1, mp_wo=35, verbose=True, clustering_method="DBSCAN"):

    centroids = None
    clusters = None

    all_centroids = []
    all_clusters = []
    percents_found = []

    for id, group, in data.groupby("tag-local-identifier"):
        cprint(f"Processing id: {id}", "magenta")

        ele_data = elevationFeature(group)
        
        # move in if no stations were found
        if ele_data is None:
            if verbose:
                print("\n")
            continue

        # calculate percent of timestamps we found temp data for
        percent_found = ele_data[ele_data["elevation"].notna()].shape[0] / group.shape[0] * 100
        if verbose:
            print("Timestamps found: ", str(round(percent_found, 3)) + "%")
        percents_found.append(percent_found)

        
        
        (clusters_ele, centroids_ele), (clusters_wo, centroids_wo)  =  with_and_without_ele(ele_data,
                                                                                            method=clustering_method,
                                                                                            r_heat=r_heat, mp_heat=mp_heat,
                                                                                            r_wo=r_wo, mp_wo=mp_wo,
                                                                                            verbose=verbose
                                                                                            )
        
       
                #### Normally centroids_heat
        centroids = centroids_ele.append(centroids_wo)
        
        if verbose:
            print(f"Elevation-Influenced centroids: {centroids_ele.shape[0]}")
            print(f"Without Elevation-Influenced centroids: {centroids_wo.shape[0]}")
            print("\n")

        centroids["tag-local-identifier"] = id

        all_centroids.append(centroids)
        all_clusters.append(clusters_wo)

    if all_centroids != []:
        centroids = pd.concat(all_centroids, ignore_index=True)
    if all_clusters != []:
        clusters = pd.concat(all_clusters, ignore_index=True)
        
    cprint(f"Number of clusters: {clusters.shape[0]}", "magenta")
    cprint(f"Number of centroids: {centroids.shape[0]}", "magenta")
        
    return centroids, clusters, percents_found



data, reference = load_movebank_data(
"/Users/h1n3z/Desktop/StressTest/Data/",
"Movement ecology of the jaguar in the largest floodplain of the world the Brazilian Pantanal")

station_data, station, extra = get_station_temps(data, fuzzy=True, verbose=True)
