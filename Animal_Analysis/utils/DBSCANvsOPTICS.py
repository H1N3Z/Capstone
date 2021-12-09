## This file compares results from DBSCAN and OPTICS clustering methods using the provided plotting method.


from utils import load_movebank_data, run_algorithm, run_algorithm2
from plotting import plot_range
import warnings
warnings.filterwarnings('ignore')
import matplotlib.pyplot as plt
import time


data, reference = load_movebank_data(
    "/Users/h1n3z/Desktop/ElephantsDBSCANResearch-main/data/Movebank",
    "ThermochronTracking Elephants Kruger 2007")

#ThermochronTracking Elephants Kruger 2007
#African elephants in Etosha National Park (data from Tsalyuk et al. 2018)


ID = "AM99"

data = data[data["tag-local-identifier"] == ID]


fig, axs = plt.subplots(nrows=1, ncols=4)


print("------- DBSCAN -------")
start = time.time()
centroids, clusters, percents_found = run_algorithm(data,
                                                    clustering_method="DBSCAN",
                                                    verbose=True,
                                                    r_wo=0.2, r_heat=0.2,
                                                    mp_wo=45, mp_heat=25,
                                                    )

print("TIME: ", time.time() - start)
print("Test", centroids)
plot_range(clusters, centroids, ax=axs[0], show=False)
axs[0].set_title("DBSCAN")


print("\n------- OPTICS -------")
start = time.time()
centroids, clusters, percents_found = run_algorithm(data,
                                                    clustering_method="OPTICS",
                                                    verbose=True,
                                                    r_wo=0.02, r_heat=0.23,
                                                    )

print("TIME: ", time.time() - start)
plot_range(clusters, centroids, ax=axs[1], show=False)
axs[1].set_title("OPTICS")



print("------- HDBSCAN -------")
start = time.time()
centroids, clusters, percents_found = run_algorithm(data,
                                                    clustering_method="HDBSCAN",
                                                    verbose=True,
                                                    r_wo=0.2, r_heat=0.2,
                                                    mp_wo=45, mp_heat=25,
                                                    )
print("TIME: ", time.time() - start)
print("Test", centroids)
plot_range(clusters, centroids, ax=axs[2], show=False)
axs[2].set_title("HDBSCAN")

print("------- AGGLO -------")
start = time.time()
centroids, clusters, percents_found = run_algorithm(data,
                                                    clustering_method="AGGLO",
                                                    verbose=True,
                                                    r_wo=0.2, r_heat=0.2,
                                                    mp_wo=45, mp_heat=25,
                                                    )
print("TIME: ", time.time() - start)
plot_range(clusters, centroids, ax=axs[3], show=False)
axs[3].set_title("AGGLO")


axs[0].get_legend().remove()
axs[1].get_legend().remove()
axs[2].get_legend().remove()
axs[3].get_legend().remove()


plt.show()

