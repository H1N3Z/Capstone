
# install dependencies
install.packages(c("Rcpp","RcppArmadillo","sp","CircStats","ellipses"))
# install moveHMM
install.packages("moveHMM")
install.packages("rgdal")
install.packages("ggmap")
install.packages("rasterVis")

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


#AG004
data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG004.csv")
places <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//places.csv")


head(data)
data <- prepData(data,type="LL",coordNames=c("location.long","location.lat"))
head(data)

# Elevation
## standardize covariate values
#data$elevation <- (data$elevation-mean(data$elevation))/sd(data$elevation)

#Tempature
## standardize covariate values
data$stationTemp <- (data$stationTemp-mean(data$stationTemp))/sd(data$stationTemp)
head(data)
## initial parameters for gamma and von Mises distributions
mu0 <- c(0.1,1) # step mean (two parameters: one for each state) 
sigma0 <- c(0.1,1) # step SD
zeromass0 <- c(0.1,0.05) # step zero-mass
stepPar0 <- c(mu0,sigma0,zeromass0)

angleMean0 <- c(pi,0) # angle mean 
kappa0 <- c(1,1) # angle concentration 
anglePar0 <- c(angleMean0,kappa0)

## call to fitting function
#m <- fitHMM(data=data,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~elevation)
#m
#plot(m, plotCI=TRUE)

## call to fitting function with stationTemp
m <- fitHMM(data=data,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~stationTemp)
m
#plot(m, plotCI=TRUE)

plot(m)


plotStationary(m, plotCI=TRUE)

head(data)

register_google(key = "AIzaSyBn8AU_idp-Ply-XMz0rlWr_A8agvf6Rwo")

lldata <- data.frame(ID=data$event.id,x=data$x, y=data$y, z=data$elevation)
head(lldata)
#plotSat(lldata, zoom=8)

#maptype="hybrid"

head(places)


a <- qmap("Etosha National Park, Africa", zoom = 8) +
  geom_path(
    aes(x = x, y = y),  colour = "blue",
    size = .5, alpha = .5,
    data = lldata, lineend = "round")

qmap("Etosha National Park, Africa", zoom = 8, maptype="hybrid") +
  geom_path(
    aes(x = x, y = y),  colour = "blue",
    size = 1, alpha = .5,
    data = lldata, lineend = "round") + geom_path(aes(x = x, y = y), colour = "red", data = trajsTable)


places <- data.frame(x=places$lon, y=places$lat)
head(places)

qmap("Etosha National Park, Africa", zoom = 8, maptype="hybrid") +
  geom_path(
    aes(x = x, y = y),  colour = "blue",
    size = .5, alpha = .5,
    data = lldata, lineend = "round") + geom_point(aes(x = x, y = y), colour = "red", data = places)


trajsTable <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//trajPaths.csv")
head(trajsTable)


install.packages('elevatr')
install.packages('raster')


library(elevatr)
library(raster)


xmin <- min(data$x)
xmax <- max(data$x)
ymin <- min(data$y)
ymax <- max(data$y)


# Generate a data frame of lat/long coordinates.
ex.df <- data.frame(x=seq(from=xmin, to=xmax, length.out=10), 
                    y=seq(from=ymin, to=ymax, length.out=10))

# Specify projection.
prj_dd <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

# Use elevatr package to get elevation data for each point.
elev  <- get_elev_raster(ex.df, prj = prj_dd, z = 10, clip = "bbox")

elev
raster::contour(elev) 

library('ggmap')
library(moveVis)
library(move)


moveD <- data.frame(x=data$x,y=data$y, timestamp=data$timestamp)

moveD <- transform(moveD, timestamp = as.POSIXct(timestamp))

head(moveD)
moveD <- df2move(moveD, proj = "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0", 
                x = "x", y = "y", time = "timestamp")

#data("move_data", package = "moveVis") # move class object
# if your tracks are present as data.frames, see df2move() for conversion

# align move_data to a uniform time scale
m <- align_move(moveD, res = 12, unit = "hours")

# create spatial frames with a OpenStreetMap watercolour map
frames <- frames_spatial(m, path_colours = c("red"),
                         map_service = "osm", map_type = "watercolor", alpha = 0.5) %>%
  add_labels(x = "Longitude", y = "Latitude") %>% # add some customizations, such as axis labels
  add_northarrow() %>%
  add_scalebar() %>%
  add_timestamps(m, type = "label") %>%
  add_progress()


frames[[2]] # preview one of the frames, e.g. the 100th frame

length(frames)


# animate frames
animate_frames(frames, out_file = "moveVis3.mov")


hist(elev, main = "Elevation (m)",
     col = "blue")


plot(elev)
starttime <- as.POSIXct('2009-10-07 12:21:00.000')
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
frames.l[[2]] 




animate_frames(frames.l, out_file = "moveVis4.mov")
