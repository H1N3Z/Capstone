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

#################
#Data Management#
#################

data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//ThermochronTracking Elephants Kruger 2007//ThermochronTracking Elephants Kruger 2007.csv")
head(data)

AM105 <- filter(data, tag.local.identifier == "AM105")
AM254 <- filter(data, tag.local.identifier == "AM254")
AM107 <- filter(data, tag.local.identifier == "AM107")
AM255 <- filter(data, tag.local.identifier == "AM255")
AM99 <- filter(data, tag.local.identifier == "AM99")
AM110 <- filter(data, tag.local.identifier == "AM110")
AM253 <- filter(data, tag.local.identifier== "AM253")
AM239 <- filter(data, tag.local.identifier == "AM239")
AM91 <- filter(data, tag.local.identifier == "AM91")
AM93 <- filter(data, tag.local.identifier == "AM93")
AM108 <- filter(data, tag.local.identifier == "AM108")
AM306 <- filter(data, tag.local.identifier == "AM306")
AM307 <- filter(data, tag.local.identifier == "AM307")

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

#Build Total Table
total <- rbind(AM254, AM105, AM107, AM255, AM99, AM110, AM253, AM239, AM91, AM93, AM108, AM306)
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

moveD

moveD <- transform(moveD, timestamp = as.POSIXct(timestamp, format="%Y-%m-%d %H:%M:%S"))
tail(moveD)
any(is.na(moveD))
moveD <- na.omit(moveD)
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
                  colours = c("0" = "steelblue4", "200" = "white",
                              "350" = "wheat1", "500" = "sienna4", "800" = "saddlebrown"),
                  legend_title = "Elevation\n(m)")

#library(extrafont)

frames.l[[50]] 

animate_frames(frames.l, out_file = "moveVisKrug2.gif")

###########
# MoveHMM #
###########

# Refresh data
total2 <- rbind(AM254, AM105, AM107, AM255, AM99, AM110, AM253, AM239, AM91, AM93, AM108, AM306)

sub_total1 <- rbind(AM254, AM105, AM107, AM255, AM99, AM110)
sub_total2 <- rbind(AM253, AM239, AM91, AM93, AM108, AM306)


# Standardize Co-variate
total2$external.temperature <- (total2$external.temperature-mean(total2$external.temperature))/sd(total2$external.temperature)
sub_total1$external.temperature <- (sub_total1$external.temperature-mean(sub_total1$external.temperature))/sd(sub_total1$external.temperature)
sub_total2$external.temperature <- (sub_total2$external.temperature-mean(sub_total2$external.temperature))/sd(sub_total2$external.temperature)

# Data Summary
summary(total2)

## initial parameters for gamma and von Mises distributions
mu0 <- c(0.1,1) # step mean (two parameters: one for each state) 
sigma0 <- c(0.1,1) # step SD
zeromass0 <- c(0.1,0.05) # step zero-mass
stepPar0 <- c(mu0,sigma0,zeromass0)

angleMean0 <- c(pi,0) # angle mean 
kappa0 <- c(1,1) # angle concentration 
anglePar0 <- c(angleMean0,kappa0)

# Fitting Model
m <- fitHMM(data=total2,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~external.temperature)
l <- fitHMM(data=sub_total1,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~external.temperature)
k <- fitHMM(data=sub_total2,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~external.temperature)
m

l
k

#########
# dBBMM #
#########

m2 <- m # reducing dataset for example
leroy.prj <- spTransform(m2, center=TRUE) 
dBB.leroy <- brownian.bridge.dyn(leroy.prj, ext=.85, raster=100, location.error=20)
plot(dBB.leroy, main="dBBMM")
UDleroy <- getVolumeUD(dBB.leroy)

par(mfrow=c(1,2))
plot(UDleroy, main="UD")

# also a contour can be added
plot(UDleroy, main="UD and contour lines")
contour(UDleroy, levels=c(0.5, 0.95), add=TRUE, lwd=c(0.5, 0.5), lty=c(2,1))


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
lldata <- data.frame(ID=total2$ID,x=total2$x, y=total2$y)
head(lldata)

##################
# For total2 #
##################

# Mapping
q <- qmap("Kruger National Park, Africa", zoom = 8) +
  geom_path(
    aes(x = x, y = y, col=ID), 
    size = .4, alpha = .6,
    data = lldata, lineend = "round")

q

##################
# For Sub_total1 #
##################

# Clean Up
lldata2 <- data.frame(ID=sub_total1$ID,x=sub_total1$x, y=sub_total1$y)
head(lldata2)

# Mapping
q <- qmap("Kruger National Park, Africa", zoom = 8) +
  geom_path(
    aes(x = x, y = y, col=ID), 
    size = .4, alpha = .6,
    data = lldata2, lineend = "round")

q


##################
# For Sub_total2 #
##################

# Clean Up
lldata3 <- data.frame(ID=sub_total2$ID,x=sub_total2$x, y=sub_total2$y)
head(lldata3)

# Mapping
q <- qmap("Kruger National Park, Africa", zoom = 8) +
  geom_path(
    aes(x = x, y = y, col=ID), 
    size = .4, alpha = .6,
    data = lldata3, lineend = "round")

q

