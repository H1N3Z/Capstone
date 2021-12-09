library("trajr")
library("sp")
library("sf")  
library("dplyr")

#Read in Data
data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG004.csv")
head(data)

FirstYear <- data[0:100,]
SecondYear <- data[1905:3810,]

##############
# First Year #
##############

a <- strptime(FirstYear$timestamp, "%Y-%m-%d %H:%M:%S")
FirstYear$timestamp <- as.numeric(a)
head(FirstYear)

trajData <- data.frame(x=FirstYear$location.long, y=FirstYear$location.lat, times=FirstYear$timestamp)
head(trajData)

trj <- TrajFromCoords(trajData)
head(trj)
plot(trj)

# Calculate speed and acceleration
derivs <- TrajDerivatives(trj)

# Plot change-in-speed and speed
plot(derivs$acceleration ~ derivs$accelerationTimes, type = 'l', col = 'red', 
     yaxt = 'n',
     xlab = 'Time (W)',
     ylab = expression(paste('Change in speed (', m/s^2, ')')))
axis(side = 2, col = "red")
lines(derivs$speed ~ derivs$speedTimes, col = 'blue')
axis(side = 4, col = "blue")
mtext('Speed (m/s)', side = 4, line = 3)
abline(h = 0, col = 'lightGrey')

mean(TrajStepLengths(trj))

#############
# Full Year #
#############
data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG004.csv")

a <- strptime(data$timestamp, "%Y-%m-%d %H:%M:%S")
data$timestamp <- as.numeric(a)
head(data)


trajData <- data.frame(x=data$location.long, y=data$location.lat, times=data$timestamp)
head(trajData)



#Create Traj Coords
trj <- TrajFromCoords(trajData)
plot(trj, lwd = 1, lty = 1)
plot(trj)

########
# For Giraffe Data get step lengths #
trj

TrajStepLengths(trj)

steps <- data.frame(dis=TrajStepLengths(trj), )
head(steps)

# End #

# Smooth before calculating derivatives
smoothed <- TrajSmoothSG(trj, 3, 31)
lines(smoothed, col = "#FF0000A0", lwd = 2)

legend("topright", c("Original", "Smoothed"), lwd = c(1, 2), lty = c(1, 1), col = c("black", "red"), inset = 0.01)

# Plot original trajectory with dots at trajectory coordinates
plot(trj, lwd = 2)
points(trj, draw.start.pt = FALSE, pch = 16, col = "black", cex = 1.2)

# Resample to 1 hourly steps
resampled <- TrajResampleTime(trj, .5)

# Plot rediscretized trajectory in red
lines(resampled, col = "#FF0000A0", lwd = 2)
points(resampled, type = 'p', col = "#FF0000A0", pch = 16)
legend("topright", c("Original", "Resampled"), col = c("black", "red"), 
       lwd = 2, inset = c(0.01, 0.02))


# Calculate speed and acceleration
derivs <- TrajDerivatives(smoothed)

# Plot change-in-speed and speed
plot(derivs$acceleration ~ derivs$accelerationTimes, type = 'l', col = 'red', 
     yaxt = 'n',
     xlab = 'Time (W)',
     ylab = expression(paste('Change in speed (', m/s^2, ')')))
axis(side = 2, col = "red")
lines(derivs$speed ~ derivs$speedTimes, col = 'blue')
axis(side = 4, col = "blue")
mtext('Speed (m/s)', side = 4, line = 3)
abline(h = 0, col = 'lightGrey')


# Calculate hovering intervals
intervals <- TrajSpeedIntervals(smoothed, diff="central", fasterThan = 2.3)
intervals
plot(intervals, xlab = 'time (W)')

corr <- TrajDirectionAutocorrelations(trj)
plot(corr)



# Rediscretize each trajectory to a range of step sizes
stepSizes <- c(1, 2, 10)
reds <- TrajRediscretize(trj, stepSizes)

# Calculate straightness (D/L) for all of the rediscretized trajectories
ds <- TrajStraightness(reds)
# Calculate alternate straightness (r) for all of the rediscretized trajectories
rs <- TrajMeanVectorOfTurningAngles(reds)

# Plot both indices on the same graph
plot(rep(angularErrorSd, 3), rs,
     pch = 16, cex = .8,
     col = c(rep('red', n), rep('blue', n), rep('darkgreen', n)),
     xlab = expression(sigma[Delta]), ylab = "Straightness",
     ylim = range(c(ds, rs)))

points(rep(angularErrorSd, 3), ds,
       pch = 3, cex = .8,
       col = c(rep('red', n), rep('blue', n), rep('darkgreen', n)))

legend("bottomleft", c(expression(italic(r)), "D/L", paste("Step length", stepSizes)), 
       pch = c(16, 3, 16, 16), 
       col = c("black", "black", "red", "blue", "darkgreen"), inset = 0.01)


data[1275,]

exp <- data %>%
  slice(1562:1573)



mean(derivs$speed)
max(derivs$speed)
min(derivs$speed)



