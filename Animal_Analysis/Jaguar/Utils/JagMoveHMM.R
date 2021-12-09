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
library(elevatr)


########
# DATA #
########

Jag_data <- read.csv("//Users//h1n3z//Desktop//StressTest//Data//Movement ecology of the jaguar in the largest floodplain of the world the Brazilian Pantanal//Movement ecology of the jaguar in the largest floodplain of the world the Brazilian Pantanal.csv")
head(Jag_data)

Jag_data <- prepData(Jag_data,type="LL",coordNames=c("location.long","location.lat"))
head(Jag_data)

############################
# Generate Raster for Elev #
############################

xmin <- min(Jag_data$x)
xmax <- max(Jag_data$x)
ymin <- min(Jag_data$y)
ymax <- max(Jag_data$y)

# Generate a data frame of lat/long coordinates.
ex.df <- data.frame(x=seq(from=xmin, to=xmax, length.out=10), 
                    y=seq(from=ymin, to=ymax, length.out=10))

# Specify projection.
prj_dd <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

# Use elevatr package to get elevation data for each point.
elev  <- get_elev_raster(ex.df, prj = prj_dd, z = 10, clip = "bbox")

raster::contour(elev)


total <- Jag_data
#######################
#Build Movement Visual# 
#######################
moveD <- data.frame(ID=total$ID, x=total$x, y=total$y, timestamp=total$timestamp)
head(moveD)
moveD <- transform(moveD, timestamp = as.POSIXct(timestamp))

moveD <- df2move(moveD, proj = "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0", 
                 x = "x", y = "y", time = "timestamp", track_id = "ID")

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
                  colours = c("92" = "black", "99.5"="gray13", "107" = "forestgreen", "114.5"= "tan4"),
                  legend_title = "Elevation\n(m)")
frames.l[[50]] 





length(frames.l)

animate_frames(frames.l, out_file = "moveVisJag.mov")


###########
# MoveHMM #
###########
Jag_data <- read.csv("//Users//h1n3z//Desktop//StressTest//Data//jag.csv")
head(Jag_data)
full_data <- prepData(Jag_data,type="LL",coordNames=c("location.long","location.lat"))


# Standardize Co-variate
full_data$stationTemp <- (full_data$stationTemp-mean(full_data$stationTemp))/sd(full_data$stationTemp)

# Data Summary
summary(full_data)

## initial parameters for gamma and von Mises distributions
mu0 <- c(0.1,1) # step mean (two parameters: one for each state) 
sigma0 <- c(0.1,1) # step SD
zeromass0 <- c(0.1,0.05) # step zero-mass
stepPar0 <- c(mu0,sigma0,zeromass0)

angleMean0 <- c(pi,0) # angle mean 
kappa0 <- c(1,1) # angle concentration 
anglePar0 <- c(angleMean0,kappa0)

# Fitting Model
m <- fitHMM(data=full_data,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~stationTemp)
m

# Plotting
plot(m)


plotStates(m)
plotStationary(m, plotCI=TRUE)

# Google API Key
register_google(key = "AIzaSyBn8AU_idp-Ply-XMz0rlWr_A8agvf6Rwo")

# Clean Up
head(full_data)
lldata <- data.frame(ID=full_data$individual.local.identifier,x=full_data$x, y=full_data$y)
head(lldata)

# Mapping
q <- qmap("Pantanal Matogrossense National Park", zoom = 9) +
  geom_path(
    aes(x = x, y = y, col=ID), 
    size = .4, alpha = .6,
    data = lldata, lineend = "round")

q



