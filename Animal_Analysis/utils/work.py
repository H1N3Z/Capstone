
# import necessary packages
import matplotlib.pyplot as plt
import geopandas as gpd
import requests

plot_locations = gpd.read_file("/Users/h1n3z/Desktop/ElephantsDBSCANResearch-main/utils/africawaterbody/Africa_waterbody.shp")

print(plot_locations)

#print(plot_locations.total_bounds)


res = requests.get('https://api.open-elevation.com/api/v1/lookup?locations=10,10|20,20|41.161758,-8.583933')

print(res.text)
