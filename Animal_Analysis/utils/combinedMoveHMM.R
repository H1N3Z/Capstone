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

AG004_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG004.csv")
head(AG004_data)
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

####################################
#Generate Raster Plot For Elevation#
####################################

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

animate_frames(frames.l, out_file = "moveVis6.gif")


###########
# MoveHMM #
###########

#Refresh Data
AG004_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG004.csv")
AG005_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG005.csv")
AG006_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG006.csv")
AG008_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG008.csv")
AG192_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG192.csv")
AG194_data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG194.csv")

AG004_data$ID <- 'AG004'
AG005_data$ID <- 'AG005'
AG006_data$ID <- 'AG006'
AG008_data$ID <- 'AG008'
AG192_data$ID <- 'AG192'
AG194_data$ID <- 'AG194'

full_data <- rbind(AG004_data, AG005_data, AG006_data, AG008_data, AG192_data, AG194_data)
full_data <- prepData(full_data,type="LL",coordNames=c("location.long","location.lat"))

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

#########
# dBBMM #
#########

sub_m <- m # reducing dataset for example
leroy.prj <- spTransform(sub_m, center=TRUE) 
dBB.leroy <- brownian.bridge.dyn(leroy.prj, ext=.85, raster=100, location.error=20)
plot(dBB.leroy, main="dBBMM")
UDleroy <- getVolumeUD(dBB.leroy)

#par(mfrow=c(1,2))
plot(UDleroy, main="UD")

# also a contour can be added
plot(UDleroy, main="UD and contour lines")

# mantaining the lower probabilities
ud95 <- UDleroy
ud95[ud95>.95] <- NA
plot(ud95, main="UD")


###############
# End of dBBM #
###############

# Plotting
plot(m)


plotStates(m)
plotStationary(m, plotCI=TRUE)

# Google API Key
register_google(key = "AIzaSyBn8AU_idp-Ply-XMz0rlWr_A8agvf6Rwo")

# Clean Up
lldata <- data.frame(ID=full_data$ID,x=full_data$x, y=full_data$y)
head(lldata)

# Mapping
q <- qmap("Etosha National Park, Africa", zoom = 8) +
  geom_path(
    aes(x = x, y = y, col=ID), 
    size = .4, alpha = .6,
    data = lldata, lineend = "round")

q

##############
# Trajectory #
##############

library("trajr")
library("sp")
library("sf")  
library("dplyr")
library(lubridate)


head(full_data)

stepsData <- data.frame(ID=full_data$ID, dis=log(full_data$step+1), temp=full_data$stationTemp, time = full_data$timestamp)

head(stepsData)

stepsData$hour <- format(as.POSIXct(stepsData$time), format = "%H:%M:%S")
stepsData$hour <- lapply(stepsData$hour, HoraDecimal)
head(stepsData)

summary(stepsData)

plot(stepsData$hour, stepsData$dis, 
     xlab="Time of Day", ylab="Distance (Log m)", pch=19, col=c("green", "red", "yellow", "blue", "purple", "orange"))

################
# Single Table #
################

test <- AG004_data
test <- prepData(AG004_data,type="LL",coordNames=c("location.long","location.lat"))
test$ID <- 'AG004'

head(test)

stepsData <- data.frame(ID=test$ID, dis=log(test$step+1), temp=test$stationTemp, time = test$timestamp)
head(stepsData)

stepsData$hour <- format(as.POSIXct(stepsData$time), format = "%H:%M:%S")
stepsData$hour <- lapply(stepsData$hour, HoraDecimal)
head(stepsData)

head(stepsData$hour)

summary(stepsData)

plot(stepsData$hour, stepsData$dis, 
     xlab="Time of Day", ylab="Distance (Log m)", pch=19)


HoraDecimal <- function(x){
  sum(unlist(lapply(strsplit(x, split=":"), as.numeric)) * c(1, 1/60, 1/3600))
}

