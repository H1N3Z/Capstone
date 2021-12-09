# This file demostrates the basic usage of the files in utils.

from utils import load_movebank_data, run_algorithm, get_nearby_settlements, get_top_n_places, nearbyWaterBodies, run_algorithm2
from plotting import plot_range
import os
import pickle
from termcolor import cprint
import colorama
colorama.init()
import pandas as pd
import warnings
warnings.filterwarnings('ignore')

##### 1.  process with geopandas and shapely
cprint("1.  process with geopandas and shapely", "cyan")

data, reference = load_movebank_data(
    "/Users/h1n3z/Desktop/ElephantsDBSCANResearch-main/data/Movebank",
    "African elephants in Etosha National Park (data from Tsalyuk et al. 2018)")


##### 2.  get temps with fuzzy matching and cluster with DBSCAN
cprint("\n2.  get temps with fuzzy matching and cluster with DBSCAN", "cyan")


centroids, clusters, percents_found = run_algorithm(data,
                                                    clustering_method="DBSCAN",
                                                    verbose=False,
                                                    r_wo=0.06, r_heat=0.2,
                                                    mp_wo=45, mp_heat=25,
                                                    )

'''
centroids, clusters, percents_found = run_algorithm(data,
                                                    clustering_method="HDBSCAN",
                                                    verbose=False,
                                                    r_wo=0.06,
                                                    r_heat=0.2,
                                                    mp_wo=45,
                                                    mp_heat=25,
                                                    )
                                                    

centroids, clusters, percents_found = run_algorithm(data,
                                                    clustering_method="AGGLO",
                                                    verbose=False,
                                                    r_wo=0.06,
                                                    r_heat=0.2,
                                                    mp_wo=45,
                                                    mp_heat=25,
                                                    )
                                                    
'''
# # ##### optionally save centroids to file
# filename = 'kruger_centroids.pkl'
# fp = os.path.join('../data/', filename)
# with open(fp, 'wb') as output:
#     pickle.dump(centroids, output)

# ##### optionally read in pre-calculated centroids
# filename = 'kruger_centroids.pkl'
# fp = os.path.join('../data/', filename)
# with open(fp, 'rb') as infile:
#     centroids = pickle.load(infile)



##### Call function to get waterbodies table for kmeans
cprint("Gathering WaterBodies", "cyan")
water = nearbyWaterBodies()

##### Call kmeans function on waterbodies
cprint("KMeans to get most active water bodies", "cyan")
opWater = get_top_n_places(centroids, water, n=10)
print(opWater[["geometry", "AF_WTR_ID", "NAME_OF_WA", "TYPE_OF_WA", "n_centroids_in_settlement_cluster"]])


##### 3. Query nearby settlements with Overpass
cprint("\n3. Query nearby settlements with Overpass", "cyan")
places = get_nearby_settlements(centroids, radius=2)

##### 4. Use KMeans to get N places
cprint("\n4. Use KMeans to get N places", "cyan")
top_10 = get_top_n_places(centroids, places, n=10)


top_10 = top_10.rename(columns={"place": "type"})
print(top_10[["geometry", "name", "type", "n_centroids_in_settlement_cluster"]])


cprint("*** Ta-da! ***", "green")





