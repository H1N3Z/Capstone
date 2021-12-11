library(data.table)
library(lubridate)
library(ggmap)

register_google("AIzaSyBpEMzVMI-4DjfYtUHCH0A402ooKqxDRac")


Kruger <- fread("ThermochronTracking_Elephants_Kruger_2007.csv")

Kruger_2007_Wet <- Kruger[year(Kruger$timestamp) %in% 2007,]
unique(Etosha_2014_Dry$timestamp)




Oct_kr_2007 <- Kruger_2007_Wet[months(Kruger_2007_Wet$timestamp) %in% month.name[10],]
Nov_kr_2007 <- Kruger_2007_Wet[months(Kruger_2007_Wet$timestamp) %in% month.name[11],]
Dec_kr_2007 <- Kruger_2007_Wet[months(Kruger_2007_Wet$timestamp) %in% month.name[12],]
Jan_kr_2007 <- Kruger_2007_Wet[months(Kruger_2007_Wet$timestamp) %in% month.name[1],]
Feb_kr_2007 <- Kruger_2007_Wet[months(Kruger_2007_Wet$timestamp) %in% month.name[2],]
Mar_kr_2007 <- Kruger_2007_Wet[months(Kruger_2007_Wet$timestamp) %in% month.name[3],]

head(Oct_kr_2007)
head(Nov_kr_2007)
head(Dec_kr_2007)
head(Jan_kr_2007)
head(Feb_kr_2007)
head(Mar_kr_2007)

t1 <- rbind(Oct_kr_2007, Nov_kr_2007)
t2 <- rbind(t1, Dec_kr_2007)
t3 <- rbind(t2, Jan_kr_2007)
t4 <- rbind(t3, Feb_kr_2007)
Wet_Kruger_2007 <- rbind(t4, Mar_kr_2007) 

Wet_Kruger_2007_New <- Wet_Kruger_2007[order(as.POSIXct(Wet_Kruger_2007$timestamp)),]
str(Wet_Kruger_2007_New)

write.csv(Wet_Kruger_2007_New, "Kruger_Wet_2007.csv")





Kruger_2008_Wet <- Kruger[year(Kruger$timestamp) %in% 2008,]
unique(Kruger_2008_Wet$timestamp)




Oct_kr_2008 <- Kruger_2008_Wet[months(Kruger_2008_Wet$timestamp) %in% month.name[10],]
Nov_kr_2008 <- Kruger_2008_Wet[months(Kruger_2008_Wet$timestamp) %in% month.name[11],]
Dec_kr_2008 <- Kruger_2008_Wet[months(Kruger_2008_Wet$timestamp) %in% month.name[12],]
Jan_kr_2008 <- Kruger_2008_Wet[months(Kruger_2008_Wet$timestamp) %in% month.name[1],]
Feb_kr_2008 <- Kruger_2008_Wet[months(Kruger_2008_Wet$timestamp) %in% month.name[2],]
Mar_kr_2008 <- Kruger_2008_Wet[months(Kruger_2008_Wet$timestamp) %in% month.name[3],]

head(Oct_kr_2008)
head(Nov_kr_2008)
head(Dec_kr_2008)
head(Jan_kr_2008)
head(Feb_kr_2008)
head(Mar_kr_2008)

t1 <- rbind(Oct_kr_2008, Nov_kr_2008)
t2 <- rbind(t1, Dec_kr_2008)
t3 <- rbind(t2, Jan_kr_2008)
t4 <- rbind(t3, Feb_kr_2008)
Wet_Kruger_2008 <- rbind(t4, Mar_kr_2008) 

Wet_Kruger_2008_New <- Wet_Kruger_2008[order(as.POSIXct(Wet_Kruger_2008$timestamp)),]
str(Wet_Kruger_2008_New)

write.csv(Wet_Kruger_2008_New, "Kruger_Wet_2008.csv")





Kruger_2009_Wet <- Kruger[year(Kruger$timestamp) %in% 2009,]
unique(Kruger_2009_Wet$timestamp)

Oct_kr_2009 <- Kruger_2009_Wet[months(Kruger_2009_Wet$timestamp) %in% month.name[10],]
Nov_kr_2009 <- Kruger_2009_Wet[months(Kruger_2009_Wet$timestamp) %in% month.name[11],]
Dec_kr_2009 <- Kruger_2009_Wet[months(Kruger_2009_Wet$timestamp) %in% month.name[12],]
Jan_kr_2009 <- Kruger_2009_Wet[months(Kruger_2009_Wet$timestamp) %in% month.name[1],]
Feb_kr_2009 <- Kruger_2009_Wet[months(Kruger_2009_Wet$timestamp) %in% month.name[2],]
Mar_kr_2009 <- Kruger_2009_Wet[months(Kruger_2009_Wet$timestamp) %in% month.name[3],]

head(Oct_kr_2009)
head(Nov_kr_2009)
head(Dec_kr_2009)
head(Jan_kr_2009)
head(Feb_kr_2009)
head(Mar_kr_2009)

t1 <- rbind(Oct_kr_2009, Nov_kr_2009)
t2 <- rbind(t1, Dec_kr_2009)
t3 <- rbind(t2, Jan_kr_2009)
t4 <- rbind(t3, Feb_kr_2009)
Wet_Kruger_2009 <- rbind(t4, Mar_kr_2009) 

Wet_Kruger_2009_New <- Wet_Kruger_2009[order(as.POSIXct(Wet_Kruger_2009$timestamp)),]
str(Wet_Kruger_2009_New)

write.csv(Wet_Kruger_2009_New, "Kruger_Wet_2009.csv")



Kruger_2007_Dry <- Kruger[year(Kruger$timestamp) %in% 2007,]
unique(Kruger_2007_Dry$timestamp)

Apr_kr_2007 <- Kruger_2007_Dry[months(Kruger_2007_Dry$timestamp) %in% month.name[4],]
May_kr_2007 <- Kruger_2007_Dry[months(Kruger_2007_Dry$timestamp) %in% month.name[5],]
Jun_kr_2007 <- Kruger_2007_Dry[months(Kruger_2007_Dry$timestamp) %in% month.name[6],]
Jul_kr_2007 <- Kruger_2007_Dry[months(Kruger_2007_Dry$timestamp) %in% month.name[7],]
Aug_kr_2007 <- Kruger_2007_Dry[months(Kruger_2007_Dry$timestamp) %in% month.name[8],]
Sep_kr_2007 <- Kruger_2007_Dry[months(Kruger_2007_Dry$timestamp) %in% month.name[9],]


head(Apr_kr_2007)
head(May_kr_2007)
head(Jun_kr_2007)
head(Jul_kr_2007)
head(Aug_kr_2007)
head(Sep_kr_2007)


t5 <- rbind(Apr_kr_2007, May_kr_2007)
t6 <- rbind(t5, Jun_kr_2007)
t7 <- rbind(t6, Jul_kr_2007)
t8 <- rbind(t7, Aug_kr_2007)
Dry_Kruger_2007 <- rbind(t8, Sep_kr_2007) 

Dry_Kruger_2007_New <- Dry_Kruger_2007[order(as.POSIXct(Dry_Kruger_2007$timestamp)),]
write.csv(Dry_Kruger_2007_New, "Kruger_Dry_2007.csv")



#CHECKPT

Kruger_2008_Dry <- Kruger[year(Kruger$timestamp) %in% 2008,]
unique(Kruger_2008_Dry$timestamp)

Apr_kr_2008 <- Kruger_2008_Dry[months(Kruger_2008_Dry$timestamp) %in% month.name[4],]
May_kr_2008 <- Kruger_2008_Dry[months(Kruger_2008_Dry$timestamp) %in% month.name[5],]
Jun_kr_2008 <- Kruger_2008_Dry[months(Kruger_2008_Dry$timestamp) %in% month.name[6],]
Jul_kr_2008 <- Kruger_2008_Dry[months(Kruger_2008_Dry$timestamp) %in% month.name[7],]
Aug_kr_2008 <- Kruger_2008_Dry[months(Kruger_2008_Dry$timestamp) %in% month.name[8],]
Sep_kr_2008 <- Kruger_2008_Dry[months(Kruger_2008_Dry$timestamp) %in% month.name[9],]


head(Apr_kr_2008)
head(May_kr_2008)
head(Jun_kr_2008)
head(Jul_kr_2008)
head(Aug_kr_2008)
head(Sep_kr_2008)


t5 <- rbind(Apr_kr_2008, May_kr_2008)
t6 <- rbind(t5, Jun_kr_2008)
t7 <- rbind(t6, Jul_kr_2008)
t8 <- rbind(t7, Aug_kr_2008)
Dry_Kruger_2008 <- rbind(t8, Sep_kr_2008) 

Dry_Kruger_2008_New <- Dry_Kruger_2008[order(as.POSIXct(Dry_Kruger_2008$timestamp)),]
write.csv(Dry_Kruger_2008_New, "Kruger_Dry_2008.csv")




Kruger_2009_Dry <- Kruger[year(Kruger$timestamp) %in% 2009,]
unique(Kruger_2009_Dry$timestamp)

Apr_kr_2009 <- Kruger_2009_Dry[months(Kruger_2009_Dry$timestamp) %in% month.name[4],]
May_kr_2009 <- Kruger_2009_Dry[months(Kruger_2009_Dry$timestamp) %in% month.name[5],]
Jun_kr_2009 <- Kruger_2009_Dry[months(Kruger_2009_Dry$timestamp) %in% month.name[6],]
Jul_kr_2009 <- Kruger_2009_Dry[months(Kruger_2009_Dry$timestamp) %in% month.name[7],]
Aug_kr_2009 <- Kruger_2009_Dry[months(Kruger_2009_Dry$timestamp) %in% month.name[8],]
Sep_kr_2009 <- Kruger_2009_Dry[months(Kruger_2009_Dry$timestamp) %in% month.name[9],]


head(Apr_kr_2009)
head(May_kr_2009)
head(Jun_kr_2009)
head(Jul_kr_2009)
head(Aug_kr_2009)
head(Sep_kr_2009)


t5 <- rbind(Apr_kr_2009, May_kr_2009)
t6 <- rbind(t5, Jun_kr_2009)
t7 <- rbind(t6, Jul_kr_2009)
t8 <- rbind(t7, Aug_kr_2009)
Dry_Kruger_2009 <- rbind(t8, Sep_kr_2009) 

Dry_Kruger_2009_New <- Dry_Kruger_2009[order(as.POSIXct(Dry_Kruger_2009$timestamp)),]
write.csv(Dry_Kruger_2009_New, "Kruger_Dry_2009.csv")





head(Kruger)
tail(Kruger)
str(Kruger)

Oct <- Kruger[months(Kruger$timestamp) %in% month.name[10],]
Nov <- Kruger[months(Kruger$timestamp) %in% month.name[11],]
Dec <- Kruger[months(Kruger$timestamp) %in% month.name[12],]
Jan <- Kruger[months(Kruger$timestamp) %in% month.name[1],]
Feb <- Kruger[months(Kruger$timestamp) %in% month.name[2],]
Mar <- Kruger[months(Kruger$timestamp) %in% month.name[3],]

head(Oct)
head(Nov)
head(Dec)
head(Jan)
head(Feb)
head(Mar)

t1 <- rbind(Oct, Nov)
t2 <- rbind(t1, Dec)
t3 <- rbind(t2, Jan)
t4 <- rbind(t3, Feb)
Wet <- rbind(t4, Mar) 

Wet <- Wet[order(as.POSIXct(Wet$timestamp)),]
str(Wet)

write.csv(Wet, "Kruger_Wet.csv")

Apr <- Kruger[months(Kruger$timestamp) %in% month.name[4],]
May <- Kruger[months(Kruger$timestamp) %in% month.name[5],]
Jun <- Kruger[months(Kruger$timestamp) %in% month.name[6],]
Jul <- Kruger[months(Kruger$timestamp) %in% month.name[7],]
Aug <- Kruger[months(Kruger$timestamp) %in% month.name[8],]
Sep <- Kruger[months(Kruger$timestamp) %in% month.name[9],]


head(Apr)
head(May)
head(Jun)
head(Jul)
head(Aug)
head(Sep)


t5 <- rbind(Apr, May)
t6 <- rbind(t5, Jun)
t7 <- rbind(t6, Jul)
t8 <- rbind(t7, Aug)
Dry <- rbind(t8, Sep) 

Dry <- Dry[order(as.POSIXct(Dry$timestamp)),]
write.csv(Dry, "Kruger_Dry.csv")

unique(Dry$'individual-local-identifier')


Area <- "Etosha National Park, namibia"
ar <- geocode(Area)
qmap(Area, maprange = TRUE, zoom = 9,
     base_layer = ggplot(aes(x=lon, y=lat), data = ar)) +
  geom_point()





Kruger_Dry_Centroids <- list(Latitude = c(-25.008716, -25.005313, -24.996471, -25.004720, -24.990260, -24.998809, -25.006143, -25.004612), 
                       Longitude = c(31.305339, 31.314879, 31.324800, 31.314384, 31.261783, 31.320631, 31.299130, 31.317461))


Kruger_Wet_Centroids <- list(Latitude = c(-25.021703, -25.073761, -25.041962, -25.058433, -25.029800, -25.086696, -24.477375, -25.073294), 
                      Longitude = c(31.374524, 31.403652, 31.362133, 31.367435, 31.358048, 31.386213, 31.391437, 31.403401))





qmap(location = "") + geom_point(aes(x = Data$Longitude, y = Data$Latitiude))
                       
where <- ""
wh <- geocode(where)
qmap(where, maprange = TRUE, zoom = 15,
     base_layer = ggplot(aes(x=lon, y=lat), data = wh)) +
  geom_point()





#Kruger Dry Centroids

Krug_DRY_lon <-  c(31.305339, 31.314879, 31.324800, 31.314384, 31.261783, 31.320631, 31.299130, 31.317461)
Krug_DRY_lat <- c(-25.008716, -25.005313, -24.996471, -25.004720, -24.990260, -24.998809, -25.006143, -25.004612)
df <- as.data.frame(cbind(Krug_DRY_lon,Krug_DRY_lat))

# getting the map 
#zoom=20
mapgilbert <- get_map(location = c(lon = max(df$Krug_DRY_lon), lat = max(df$Krug_DRY_lat)), zoom = 2,
                      maptype = "satellite", scale = "none")

# plotting the map with some points on it
ggmap(mapgilbert) +
  geom_point(data = df, aes(x = Krug_DRY_lon, y = Krug_DRY_lat, fill = "blue", alpha = 0.8), size = 5, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)





#Kruger Wet Centroids

Krug_WET_lon <-  c(31.374524, 31.403652, 31.362133, 31.367435, 31.358048, 31.386213, 31.391437, 31.403401)
Krug_WET_lat <- c(-25.021703, -25.073761, -25.041962, -25.058433, -25.029800, -25.086696, -24.477375, -25.073294)
df <- as.data.frame(cbind(Krug_WET_lon,Krug_WET_lat))

# getting the map
mapgilbert <- get_map(location = c(lon = mean(df$Krug_WET_lon), lat = mean(df$Krug_WET_lat)), zoom = 20,
                      maptype = "satellite", scale = "none")

# plotting the map with some points on it
ggmap(mapgilbert) +
  geom_point(data = df, aes(x = Krug_WET_lon, y = Krug_WET_lat, fill = "red", alpha = 0.8), size = 5, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)




