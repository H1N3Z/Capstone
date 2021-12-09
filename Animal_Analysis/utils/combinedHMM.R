
library(MASS)
library(boot)
library(CircStats)
library(sp)
library(Rcpp)
library(moveHMM)
library(rgdal)
library(ggmap)
library(ggplot2)
# spatial
library(raster)
library(rasterVis)
library('ggmap')
library(moveVis)
library(move)

#All Data Pulling
AG004_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG004.csv")
AG005_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG005.csv")
AG006_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG006.csv")
AG008_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG008.csv")
AG192_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG192.csv")
AG194_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG194.csv")

AG004_data <- prepData(AG004_data,type="LL",coordNames=c("location.long","location.lat"))
AG005_data <- prepData(AG005_data,type="LL",coordNames=c("location.long","location.lat"))
AG006_data <- prepData(AG006_data,type="LL",coordNames=c("location.long","location.lat"))
AG008_data <- prepData(AG008_data,type="LL",coordNames=c("location.long","location.lat"))
AG192_data <- prepData(AG192_data,type="LL",coordNames=c("location.long","location.lat"))
AG194_data <- prepData(AG194_data,type="LL",coordNames=c("location.long","location.lat"))

AG004_data$ID <- 'AG004'
AG005_data$ID <- 'AG005'
AG006_data$ID <- 'AG006'
AG008_data$ID <- 'AG008'
AG192_data$ID <- 'AG192'
AG194_data$ID <- 'AG194'

total <- rbind(AG004_data, AG005_data, AG006_data, AG008_data, AG192_data, AG194_data)

head(total)

xmin <- min(total$x)
xmax <- max(total$x)
ymin <- min(total$y)
ymax <- max(total$y)


# Generate a data frame of lat/long coordinates.
ex.df <- data.frame(x=seq(from=xmin, to=xmax, length.out=10), 
                    y=seq(from=ymin, to=ymax, length.out=10))

# Specify projection.
prj_dd <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

# Use elevatr package to get elevation data for each point.
elev  <- get_elev_raster(ex.df, prj = prj_dd, z = 10, clip = "bbox")

raster::contour(elev)

#Movement
moveD <- data.frame(ID=total$ID, x=total$x, y=total$y, timestamp=total$timestamp)
head(moveD)
moveD <- transform(moveD, timestamp = as.POSIXct(timestamp))

moveD <- df2move(moveD, proj = "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0", 
                 x = "x", y = "y", time = "timestamp", track_id = "ID")

# align move_data to a uniform time scale
m <- align_move(moveD, res = 1, unit = "days")

min(moveD$time)



starttime <- as.POSIXct('2008-10-30 00:15:00.000')
frames <- frames_spatial(m, r_list = elev, r_times = starttime, 
                         r_type = "gradient", fade_raster = FALSE, equidistant = FALSE,
                         path_legend = T, alpha = 0.9)


frames.l <- add_labels(frames, x = "Longitude", y = "Latitude") %>%
  add_progress() %>%
  add_timestamps(m, type = "label") %>%
  add_progress() %>%
  add_colourscale(type = "gradient", 
                  colours = c("1000" = "steelblue4", "1086" = "white",
                              "1100" = "wheat1", "1290" = "sienna4", "1400" = "saddlebrown"),
                  legend_title = "Elevation\n(m)")
frames.l[[50]] 

length(frames.l)

animate_frames(frames.l, out_file = "moveVis4.mov")



