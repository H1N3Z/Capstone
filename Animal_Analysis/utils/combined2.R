
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
library(dplyr)  

data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//ThermochronTracking Elephants Kruger 2007//ThermochronTracking Elephants Kruger 2007.csv")
head(data)

#data <- na.omit(data)
any(is.na(data))

AM105 <- filter(data, individual.local.identifier == "AM105")
AM254 <- filter(data, individual.local.identifier == "AM254")
AM107 <- filter(data, individual.local.identifier == "AM107")
AM255 <- filter(data, individual.local.identifier == "AM255")
AM99 <- filter(data, individual.local.identifier == "AM99")
AM110 <- filter(data, individual.local.identifier == "AM110")
AM253 <- filter(data, individual.local.identifier== "AM253")
AM239 <- filter(data, individual.local.identifier == "AM239")
AM91 <- filter(data, individual.local.identifier == "AM91")
AM93 <- filter(data, individual.local.identifier == "AM93")
AM108 <- filter(data, individual.local.identifier == "AM108")
AM306 <- filter(data, individual.local.identifier == "AM306")
AM307 <- filter(data, individual.local.identifier == "AM307")
AM308 <- filter(data, individual.local.identifier== "AM308")


AM254 <- prepData(AM254,type="LL",coordNames=c("location.long","location.lat"))
AM107 <- prepData(AM107,type="LL",coordNames=c("location.long","location.lat"))
AM255 <- prepData(AM255,type="LL",coordNames=c("location.long","location.lat"))
AM99 <- prepData(AM99,type="LL",coordNames=c("location.long","location.lat"))
AM110 <- prepData(AM110,type="LL",coordNames=c("location.long","location.lat"))
AM253 <- prepData(AM253,type="LL",coordNames=c("location.long","location.lat"))
AM105 <- prepData(AM105,type="LL",coordNames=c("location.long","location.lat"))
AM239 <- prepData(AM239,type="LL",coordNames=c("location.long","location.lat"))
AM91 <- prepData(AM91,type="LL",coordNames=c("location.long","location.lat"))
AM93 <- prepData(AM93,type="LL",coordNames=c("location.long","location.lat"))
AM108 <- prepData(AM108,type="LL",coordNames=c("location.long","location.lat"))
AM306 <- prepData(AM306,type="LL",coordNames=c("location.long","location.lat"))
AM307 <- prepData(AM307,type="LL",coordNames=c("location.long","location.lat"))
AM308 <- prepData(AM308,type="LL",coordNames=c("location.long","location.lat"))

AM254$ID <- 'AM254'
AM107$ID <- 'AM107'
AM255$ID <- 'AM255'
AM99$ID <- 'AM99'
AM110$ID <- 'AM110'
AM253$ID <- 'AM253'
AM105$ID <- 'AM105'
AM239$ID <- 'AM239'
AM91$ID <- 'AM91'
AM93$ID <- 'AM93'
AM108$ID <- 'AM108'
AM306$ID <- 'AM306'
AM307$ID <- 'AM307'
AM308$ID <- 'AM308'


total <- rbind(AM254,
               AM107,
               AM255,
               AM99,
               AM110,
               AM253,
               AM105,
               AM239,
               AM91,
               AM93,
               AM108,
               AM306,
               AM307,
               AM308)

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
any(is.na(moveD))

moveD <- transform(moveD, timestamp = as.POSIXct(timestamp, tz = "", "%Y-%m-%d %H:%M:%OS"))
any(is.na(moveD))
moveD <- na.omit(moveD)
moveD

moveD <- df2move(moveD, proj = "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0", 
                 x = "x", y = "y", time = "timestamp", track_id = "ID")

moveD

# align move_data to a uniform time scale
m <- align_move(moveD, res = 1, unit = "days")

min(moveD$time)


starttime <- as.POSIXct(min(moveD$time))
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



