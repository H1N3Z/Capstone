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
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)


########
# DATA #
########

data67 <- read.csv("//Users//h1n3z//Desktop//cattle//2006.07.13//067.txt", sep="|", header = FALSE, skip = 1)
data67$ID <- 67
data125 <- read.csv("//Users//h1n3z//Desktop//cattle//2006.07.13//125.txt", sep="|", header = FALSE, skip = 1)
data125$ID <- 125
data375 <- read.csv("//Users//h1n3z//Desktop//cattle//2006.07.13//375.txt", sep="|", header = FALSE, skip = 1)
data375$ID <- 375
data403 <- read.csv("//Users//h1n3z//Desktop//cattle//2006.07.13//403.txt", sep="|", header = FALSE, skip = 1)
data403$ID <- 403
data <- rbind(data67, data125, data375, data403)


head(data)
data <- data %>% separate(V2, c('temp', 'Time'), "=")
data <- data %>% separate(V3, c('temp2', 'Date'), "=")
data <- data %>% separate(V4, c('temp3', 'Lat'), "=")
data <- data %>% separate(V5, c('temp4', 'Long'), "=")

summary(data)
data <- na.omit(data)

data <- data.frame(ID=data$ID, Time=as.POSIXct(as.numeric(data$Time), origin = "1970-01-01", tz=""), Date=as.numeric(data$Date), Lat=as.numeric(data$Lat), Long=as.numeric(data$Long))
head(data)

data <- prepData(data,type="LL",coordNames=c("Long","Lat"))
head(data)


############################
# Generate Raster for Elev #
############################

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

raster::contour(elev)


total <-data
head(total)
summary(total)


#######################
#Build Movement Visual# 
#######################

moveD <- data.frame(ID=total$ID, x=total$x, y=total$y, timestamp=total$Time)
head(moveD)
moveD <- transform(moveD, timestamp = as.POSIXct(timestamp))

moveD <- df2move(moveD, proj = "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0", 
                 x = "x", y = "y", time = "timestamp", track_id = "ID")

# align move_data to a uniform time scale
m <- align_move(moveD, res = 1, unit = "days")

min(moveD$time)

starttime <- min(moveD$time)

frames.l <- frames_spatial(m, path_colours = c("red", "green", "blue", "purple"), map_service = "mapbox", map_type = "satellite",
                           map_token = "pk.eyJ1IjoiaGluZXM1MTciLCJhIjoiY2t3azNsa3A1MW9leDJwdXQxc3dpZ2wxNiJ9.nGJkEamvyZ4LRfZNoMufwQ")


frames.l[[50]] 

length(frames.l)

animate_frames(frames.l, out_file = "moveVisCattle.mov")

###########
# MoveHMM #
###########

full_data <- total

# Standardize Co-variate
full_data$stationTemp <- (data$stationTemp-mean(data$stationTemp))/sd(data$stationTemp)

# Data Summary
summary(full_data)

## initial parameters for gamma and von Mises distributions
mu0 <- c(1,1) #(state1,state2)
sigma0 <- c(50,30) #(state1,state2)
zero_mass0 <- c(0,1)
stepPar0 <- c(mu0,sigma0,zeromass0)

angleMean0 <- c(pi,0) # angle mean 
kappa0 <- c(1,1) # angle concentration 
anglePar0 <- c(angleMean0,kappa0)

# Fitting Model
m <- fitHMM(data=full_data,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~Date)
m

# Plotting
plot(m)


plotStates(m)
plotStationary(m, plotCI=TRUE)

# Google API Key
register_google(key = "AIzaSyBn8AU_idp-Ply-XMz0rlWr_A8agvf6Rwo")

# Clean Up
head(full_data)
full_data <- na.omit(full_data)
lldata <- data.frame(ID=full_data$ID,x=full_data$x, y=full_data$y)
head(lldata)

# Mapping
q <- qmap("Sutton Bonington Dairy", zoom = 17, maptype = "satellite") +
  geom_path(
    aes(x = x, y = y, col=ID), 
    size = .4, alpha = .6,
    data = lldata, lineend = "round")

q






