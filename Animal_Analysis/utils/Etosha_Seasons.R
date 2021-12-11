library(data.table)
library(lubridate)
library(ggmap)

register_google("AIzaSyBpEMzVMI-4DjfYtUHCH0A402ooKqxDRac")


Etosha <- fread("Etosha_National_Park.csv")

head(Etosha)
tail(Etosha)
str(Etosha)

Etosha_2008 <- Etosha[year(Etosha$timestamp) %in% 2008,]
unique(Etosha_2008$timestamp)

Nov_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[11],]
Dec_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[12],]
Jan_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[1],]
Feb_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[2],]
Mar_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[3],]
Apr_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[4],]

head(Nov_Et_2008)
head(Dec_Et_2008)
head(Jan_Et_2008)
head(Feb_Et_2008)
head(Mar_Et_2008)
head(Apr_Et_2008)

t1 <- rbind(Nov_Et_2008, Dec_Et_2008)
t2 <- rbind(t1, Jan_Et_2008)
t3 <- rbind(t2, Feb_Et_2008)
t4 <- rbind(t3, Mar_Et_2008)
Wet_Etosha_2008 <- t1

Wet_Etosha_2008_New <- Wet_Etosha_2008[order(as.POSIXct(Wet_Etosha_2008$timestamp)),]
str(Wet_Etosha_2008_New)

unique(Wet_Etosha_2008_New$timestamp)

write.csv(Wet_Etosha_2008_New, "Wet_Etosha_2008.csv")



Etosha_2009 <- Etosha[year(Etosha$timestamp) %in% 2009,]
unique(Etosha_2009$timestamp)

Nov_Et_2009 <- Etosha_2009[months(Etosha_2009$timestamp) %in% month.name[11],]
Dec_Et_2009 <- Etosha_2009[months(Etosha_2009$timestamp) %in% month.name[12],]
Jan_Et_2009 <- Etosha_2009[months(Etosha_2009$timestamp) %in% month.name[1],]
Feb_Et_2009 <- Etosha_2009[months(Etosha_2009$timestamp) %in% month.name[2],]
Mar_Et_2009 <- Etosha_2009[months(Etosha_2009$timestamp) %in% month.name[3],]
Apr_Et_2009 <- Etosha_2009[months(Etosha_2009$timestamp) %in% month.name[4],]

head(Nov_Et_2009)
head(Dec_Et_2009)
head(Jan_Et_2009)
head(Feb_Et_2009)
head(Mar_Et_2009)
head(Apr_Et_2009)

t1 <- rbind(Nov_Et_2009, Dec_Et_2009)
t2 <- rbind(t1, Jan_Et_2009)
t3 <- rbind(t2, Feb_Et_2009)
t4 <- rbind(t3, Mar_Et_2009)
Wet_Etosha_2009 <- rbind(t4, Apr_Et_2009) 

Wet_Etosha_2009 <- Wet_Etosha_2009[order(as.POSIXct(Wet_Etosha_2009$timestamp)),]
str(Wet_Etosha_2009)

unique(Wet_Etosha_2009$timestamp)

write.csv(Wet_Etosha_2009, "Wet_Etosha_2009.csv")


Etosha_2010 <- Etosha[year(Etosha$timestamp) %in% 2010,]
unique(Etosha_2010$timestamp)

Nov_Et_2010 <- Etosha_2010[months(Etosha_2010$timestamp) %in% month.name[11],]
Dec_Et_2010 <- Etosha_2010[months(Etosha_2010$timestamp) %in% month.name[12],]
Jan_Et_2010 <- Etosha_2010[months(Etosha_2010$timestamp) %in% month.name[1],]
Feb_Et_2010 <- Etosha_2010[months(Etosha_2010$timestamp) %in% month.name[2],]
Mar_Et_2010 <- Etosha_2010[months(Etosha_2010$timestamp) %in% month.name[3],]
Apr_Et_2010 <- Etosha_2010[months(Etosha_2010$timestamp) %in% month.name[4],]

head(Nov_Et_2010)
head(Dec_Et_2010)
head(Jan_Et_2010)
head(Feb_Et_2010)
head(Mar_Et_2010)
head(Apr_Et_2010)

t1 <- rbind(Nov_Et_2010, Dec_Et_2010)
t2 <- rbind(t1, Jan_Et_2010)
t3 <- rbind(t2, Feb_Et_2010)
t4 <- rbind(t3, Mar_Et_2010)
Wet_Etosha_2010 <- rbind(t4, Apr_Et_2010) 

Wet_Etosha_2010 <- Wet_Etosha_2010[order(as.POSIXct(Wet_Etosha_2010$timestamp)),]
str(Wet_Etosha_2010)

unique(Wet_Etosha_2010$timestamp)

write.csv(Wet_Etosha_2010, "Wet_Etosha_2010.csv")


Etosha_2011 <- Etosha[year(Etosha$timestamp) %in% 2011,]
unique(Etosha_2011$timestamp)

Nov_Et_2011 <- Etosha_2011[months(Etosha_2011$timestamp) %in% month.name[11],]
Dec_Et_2011 <- Etosha_2011[months(Etosha_2011$timestamp) %in% month.name[12],]
Jan_Et_2011 <- Etosha_2011[months(Etosha_2011$timestamp) %in% month.name[1],]
Feb_Et_2011 <- Etosha_2011[months(Etosha_2011$timestamp) %in% month.name[2],]
Mar_Et_2011 <- Etosha_2011[months(Etosha_2011$timestamp) %in% month.name[3],]
Apr_Et_2011 <- Etosha_2011[months(Etosha_2011$timestamp) %in% month.name[4],]

head(Nov_Et_2011)
head(Dec_Et_2011)
head(Jan_Et_2011)
head(Feb_Et_2011)
head(Mar_Et_2011)
head(Apr_Et_2011)

t1 <- rbind(Nov_Et_2011, Dec_Et_2011)
t2 <- rbind(t1, Jan_Et_2011)
t3 <- rbind(t2, Feb_Et_2011)
t4 <- rbind(t3, Mar_Et_2011)
Wet_Etosha_2011 <- rbind(t4, Apr_Et_2011) 

Wet_Etosha_2011 <- Wet_Etosha_2011[order(as.POSIXct(Wet_Etosha_2011$timestamp)),]
str(Wet_Etosha_2011)

unique(Wet_Etosha_2011$timestamp)

write.csv(Wet_Etosha_2011, "Wet_Etosha_2011.csv")




Etosha_2012 <- Etosha[year(Etosha$timestamp) %in% 2012,]
unique(Etosha_2012$timestamp)

Nov_Et_2012 <- Etosha_2012[months(Etosha_2012$timestamp) %in% month.name[11],]
Dec_Et_2012 <- Etosha_2012[months(Etosha_2012$timestamp) %in% month.name[12],]
Jan_Et_2012 <- Etosha_2012[months(Etosha_2012$timestamp) %in% month.name[1],]
Feb_Et_2012 <- Etosha_2012[months(Etosha_2012$timestamp) %in% month.name[2],]
Mar_Et_2012 <- Etosha_2012[months(Etosha_2012$timestamp) %in% month.name[3],]
Apr_Et_2012 <- Etosha_2012[months(Etosha_2012$timestamp) %in% month.name[4],]

head(Nov_Et_2012)
head(Dec_Et_2012)
head(Jan_Et_2012)
head(Feb_Et_2012)
head(Mar_Et_2012)
head(Apr_Et_2012)

t1 <- rbind(Nov_Et_2012, Dec_Et_2012)
t2 <- rbind(t1, Jan_Et_2012)
t3 <- rbind(t2, Feb_Et_2012)
t4 <- rbind(t3, Mar_Et_2012)
Wet_Etosha_2012 <- rbind(t4, Apr_Et_2012) 

Wet_Etosha_2012 <- Wet_Etosha_2012[order(as.POSIXct(Wet_Etosha_2012$timestamp)),]
str(Wet_Etosha_2012)

unique(Wet_Etosha_2012$timestamp)

write.csv(Wet_Etosha_2012, "Wet_Etosha_2012.csv")


Etosha_2013 <- Etosha[year(Etosha$timestamp) %in% 2013,]
unique(Etosha_2013$timestamp)

Nov_Et_2013 <- Etosha_2013[months(Etosha_2013$timestamp) %in% month.name[11],]
Dec_Et_2013 <- Etosha_2013[months(Etosha_2013$timestamp) %in% month.name[12],]
Jan_Et_2013 <- Etosha_2013[months(Etosha_2013$timestamp) %in% month.name[1],]
Feb_Et_2013 <- Etosha_2013[months(Etosha_2013$timestamp) %in% month.name[2],]
Mar_Et_2013 <- Etosha_2013[months(Etosha_2013$timestamp) %in% month.name[3],]
Apr_Et_2013 <- Etosha_2013[months(Etosha_2013$timestamp) %in% month.name[4],]

head(Nov_Et_2013)
head(Dec_Et_2013)
head(Jan_Et_2013)
head(Feb_Et_2013)
head(Mar_Et_2013)
head(Apr_Et_2013)

t1 <- rbind(Nov_Et_2013, Dec_Et_2013)
t2 <- rbind(t1, Jan_Et_2013)
t3 <- rbind(t2, Feb_Et_2013)
t4 <- rbind(t3, Mar_Et_2013)
Wet_Etosha_2013 <- rbind(t4, Apr_Et_2013) 

Wet_Etosha_2013 <- Wet_Etosha_2013[order(as.POSIXct(Wet_Etosha_2013$timestamp)),]
str(Wet_Etosha_2013)

unique(Wet_Etosha_2013$timestamp)

write.csv(Wet_Etosha_2013, "Wet_Etosha_2013.csv")


Etosha_2014 <- Etosha[year(Etosha$timestamp) %in% 2014,]
unique(Etosha_2014$timestamp)

Nov_Et_2014 <- Etosha_2014[months(Etosha_2014$timestamp) %in% month.name[11],]
Dec_Et_2014 <- Etosha_2014[months(Etosha_2014$timestamp) %in% month.name[12],]
Jan_Et_2014 <- Etosha_2014[months(Etosha_2014$timestamp) %in% month.name[1],]
Feb_Et_2014 <- Etosha_2014[months(Etosha_2014$timestamp) %in% month.name[2],]
Mar_Et_2014 <- Etosha_2014[months(Etosha_2014$timestamp) %in% month.name[3],]
Apr_Et_2014 <- Etosha_2014[months(Etosha_2014$timestamp) %in% month.name[4],]

head(Nov_Et_2014)
head(Dec_Et_2014)
head(Jan_Et_2014)
head(Feb_Et_2014)
head(Mar_Et_2014)
head(Apr_Et_2014)

t1 <- rbind(Nov_Et_2014, Dec_Et_2014)
t2 <- rbind(t1, Jan_Et_2014)
t3 <- rbind(t2, Feb_Et_2014)
t4 <- rbind(t3, Mar_Et_2014)
Wet_Etosha_2014 <- rbind(t4, Apr_Et_2014) 

Wet_Etosha_2014 <- Wet_Etosha_2014[order(as.POSIXct(Wet_Etosha_2014$timestamp)),]
str(Wet_Etosha_2014)

unique(Wet_Etosha_2014$timestamp)

write.csv(Wet_Etosha_2014, "Wet_Etosha_2014.csv")





Nov <- Etosha[months(Etosha$timestamp) %in% month.name[11],]
Dec <- Etosha[months(Etosha$timestamp) %in% month.name[12],]
Jan <- Etosha[months(Etosha$timestamp) %in% month.name[1],]
Feb <- Etosha[months(Etosha$timestamp) %in% month.name[2],]
Mar <- Etosha[months(Etosha$timestamp) %in% month.name[3],]
Apr <- Etosha[months(Etosha$timestamp) %in% month.name[4],]

head(Nov)
head(Dec)
head(Jan)
head(Feb)
head(Mar)
head(Apr)

t1 <- rbind(Nov, Dec)
t2 <- rbind(t1, Jan)
t3 <- rbind(t2, Feb)
t4 <- rbind(t3, Mar)
Wet <- rbind(t4, Apr) 

Wet <- Wet[order(as.POSIXct(Wet$timestamp)),]
str(Wet)

write.csv(Wet, "Wet.csv")












Etosha_2008_Dry <- Etosha[year(Etosha$timestamp) %in% 2008,]
unique(Etosha_2008_Dry$timestamp)

May_Et_2008 <- Etosha_2008_Dry[months(Etosha_2008_Dry$timestamp) %in% month.name[5],]
Jun_Et_2008 <- Etosha_2008_Dry[months(Etosha_2008_Dry$timestamp) %in% month.name[6],]
Jul_Et_2008 <- Etosha_2008_Dry[months(Etosha_2008_Dry$timestamp) %in% month.name[7],]
Aug_Et_2008 <- Etosha_2008_Dry[months(Etosha_2008_Dry$timestamp) %in% month.name[8],]
Sep_Et_2008 <- Etosha_2008_Dry[months(Etosha_2008_Dry$timestamp) %in% month.name[9],]
Oct_Et_2008 <- Etosha_2008_Dry[months(Etosha_2008_Dry$timestamp) %in% month.name[10],]


head(May_Et_2008)
head(Jun_Et_2008)
head(Jul_Et_2008)
head(Aug_Et_2008)
head(Sep_Et_2008)
head(Oct_Et_2008)

t5 <- rbind(May_Et_2008, Jun_Et_2008)
t6 <- rbind(t5, Jul_Et_2008)
t7 <- rbind(t6, Aug_Et_2008)
t8 <- rbind(t7, Sep_Et_2008)
Dry_Etosha_2008 <- rbind(t8, Oct_Et_2008) 

Dry_Etosha_2008_New <- Dry_Etosha_2008[order(as.POSIXct(Dry_Etosha_2008$timestamp)),]
write.csv(Dry_Etosha_2008_New, "Dry_Etosha_2008.csv")





Etosha_2009_Dry <- Etosha[year(Etosha$timestamp) %in% 2009,]
unique(Etosha_2009_Dry$timestamp)

May_Et_2009 <- Etosha_2009_Dry[months(Etosha_2009_Dry$timestamp) %in% month.name[5],]
Jun_Et_2009 <- Etosha_2009_Dry[months(Etosha_2009_Dry$timestamp) %in% month.name[6],]
Jul_Et_2009 <- Etosha_2009_Dry[months(Etosha_2009_Dry$timestamp) %in% month.name[7],]
Aug_Et_2009 <- Etosha_2009_Dry[months(Etosha_2009_Dry$timestamp) %in% month.name[8],]
Sep_Et_2009 <- Etosha_2009_Dry[months(Etosha_2009_Dry$timestamp) %in% month.name[9],]
Oct_Et_2009 <- Etosha_2009_Dry[months(Etosha_2009_Dry$timestamp) %in% month.name[10],]


head(May_Et_2009)
head(Jun_Et_2009)
head(Jul_Et_2009)
head(Aug_Et_2009)
head(Sep_Et_2009)
head(Oct_Et_2009)

t5 <- rbind(May_Et_2009, Jun_Et_2009)
t6 <- rbind(t5, Jul_Et_2009)
t7 <- rbind(t6, Aug_Et_2009)
t8 <- rbind(t7, Sep_Et_2009)
Dry_Etosha_2009 <- rbind(t8, Oct_Et_2009) 

Dry_Etosha_2009_New <- Dry_Etosha_2009[order(as.POSIXct(Dry_Etosha_2009$timestamp)),]
write.csv(Dry_Etosha_2009_New, "Dry_Etosha_2009.csv")




Etosha_2010_Dry <- Etosha[year(Etosha$timestamp) %in% 2010,]
unique(Etosha_2010_Dry$timestamp)

May_Et_2010 <- Etosha_2010_Dry[months(Etosha_2010_Dry$timestamp) %in% month.name[5],]
Jun_Et_2010 <- Etosha_2010_Dry[months(Etosha_2010_Dry$timestamp) %in% month.name[6],]
Jul_Et_2010 <- Etosha_2010_Dry[months(Etosha_2010_Dry$timestamp) %in% month.name[7],]
Aug_Et_2010 <- Etosha_2010_Dry[months(Etosha_2010_Dry$timestamp) %in% month.name[8],]
Sep_Et_2010 <- Etosha_2010_Dry[months(Etosha_2010_Dry$timestamp) %in% month.name[9],]
Oct_Et_2010 <- Etosha_2010_Dry[months(Etosha_2010_Dry$timestamp) %in% month.name[10],]


head(May_Et_2010)
head(Jun_Et_2010)
head(Jul_Et_2010)
head(Aug_Et_2010)
head(Sep_Et_2010)
head(Oct_Et_2010)

t5 <- rbind(May_Et_2010, Jun_Et_2010)
t6 <- rbind(t5, Jul_Et_2010)
t7 <- rbind(t6, Aug_Et_2010)
t8 <- rbind(t7, Sep_Et_2010)
Dry_Etosha_2010 <- rbind(t8, Oct_Et_2010) 

Dry_Etosha_2010_New <- Dry_Etosha_2010[order(as.POSIXct(Dry_Etosha_2010$timestamp)),]
write.csv(Dry_Etosha_2010_New, "Dry_Etosha_2010.csv")




Etosha_2011_Dry <- Etosha[year(Etosha$timestamp) %in% 2011,]
unique(Etosha_2011_Dry$timestamp)

May_Et_2011 <- Etosha_2011_Dry[months(Etosha_2011_Dry$timestamp) %in% month.name[5],]
Jun_Et_2011 <- Etosha_2011_Dry[months(Etosha_2011_Dry$timestamp) %in% month.name[6],]
Jul_Et_2011 <- Etosha_2011_Dry[months(Etosha_2011_Dry$timestamp) %in% month.name[7],]
Aug_Et_2011 <- Etosha_2011_Dry[months(Etosha_2011_Dry$timestamp) %in% month.name[8],]
Sep_Et_2011 <- Etosha_2011_Dry[months(Etosha_2011_Dry$timestamp) %in% month.name[9],]
Oct_Et_2011 <- Etosha_2011_Dry[months(Etosha_2011_Dry$timestamp) %in% month.name[10],]


head(May_Et_2011)
head(Jun_Et_2011)
head(Jul_Et_2011)
head(Aug_Et_2011)
head(Sep_Et_2011)
head(Oct_Et_2011)

t5 <- rbind(May_Et_2011, Jun_Et_2011)
t6 <- rbind(t5, Jul_Et_2011)
t7 <- rbind(t6, Aug_Et_2011)
t8 <- rbind(t7, Sep_Et_2011)
Dry_Etosha_2011 <- rbind(t8, Oct_Et_2011) 

Dry_Etosha_2011_New <- Dry_Etosha_2011[order(as.POSIXct(Dry_Etosha_2011$timestamp)),]
write.csv(Dry_Etosha_2011_New, "Dry_Etosha_2011.csv")





Etosha_2012_Dry <- Etosha[year(Etosha$timestamp) %in% 2012,]
unique(Etosha_2012_Dry$timestamp)

May_Et_2012 <- Etosha_2012_Dry[months(Etosha_2012_Dry$timestamp) %in% month.name[5],]
Jun_Et_2012 <- Etosha_2012_Dry[months(Etosha_2012_Dry$timestamp) %in% month.name[6],]
Jul_Et_2012 <- Etosha_2012_Dry[months(Etosha_2012_Dry$timestamp) %in% month.name[7],]
Aug_Et_2012 <- Etosha_2012_Dry[months(Etosha_2012_Dry$timestamp) %in% month.name[8],]
Sep_Et_2012 <- Etosha_2012_Dry[months(Etosha_2012_Dry$timestamp) %in% month.name[9],]
Oct_Et_2012 <- Etosha_2012_Dry[months(Etosha_2012_Dry$timestamp) %in% month.name[10],]


head(May_Et_2012)
head(Jun_Et_2012)
head(Jul_Et_2012)
head(Aug_Et_2012)
head(Sep_Et_2012)
head(Oct_Et_2012)

t5 <- rbind(May_Et_2012, Jun_Et_2012)
t6 <- rbind(t5, Jul_Et_2012)
t7 <- rbind(t6, Aug_Et_2012)
t8 <- rbind(t7, Sep_Et_2012)
Dry_Etosha_2012 <- rbind(t8, Oct_Et_2012) 

Dry_Etosha_2012_New <- Dry_Etosha_2012[order(as.POSIXct(Dry_Etosha_2012$timestamp)),]
write.csv(Dry_Etosha_2012_New, "Dry_Etosha_2012.csv")



Etosha_2013_Dry <- Etosha[year(Etosha$timestamp) %in% 2013,]
unique(Etosha_2013_Dry$timestamp)

May_Et_2013 <- Etosha_2013_Dry[months(Etosha_2013_Dry$timestamp) %in% month.name[5],]
Jun_Et_2013 <- Etosha_2013_Dry[months(Etosha_2013_Dry$timestamp) %in% month.name[6],]
Jul_Et_2013 <- Etosha_2013_Dry[months(Etosha_2013_Dry$timestamp) %in% month.name[7],]
Aug_Et_2013 <- Etosha_2013_Dry[months(Etosha_2013_Dry$timestamp) %in% month.name[8],]
Sep_Et_2013 <- Etosha_2013_Dry[months(Etosha_2013_Dry$timestamp) %in% month.name[9],]
Oct_Et_2013 <- Etosha_2013_Dry[months(Etosha_2013_Dry$timestamp) %in% month.name[10],]


head(May_Et_2013)
head(Jun_Et_2013)
head(Jul_Et_2013)
head(Aug_Et_2013)
head(Sep_Et_2013)
head(Oct_Et_2013)

t5 <- rbind(May_Et_2013, Jun_Et_2013)
t6 <- rbind(t5, Jul_Et_2013)
t7 <- rbind(t6, Aug_Et_2013)
t8 <- rbind(t7, Sep_Et_2013)
Dry_Etosha_2013 <- rbind(t8, Oct_Et_2013) 

Dry_Etosha_2013_New <- Dry_Etosha_2013[order(as.POSIXct(Dry_Etosha_2013$timestamp)),]
write.csv(Dry_Etosha_2013_New, "Dry_Etosha_2013.csv")



#NULL Dataset
Etosha_2014_Dry <- Etosha[year(Etosha$timestamp) %in% 2014,]
unique(Etosha_2014_Dry$timestamp)

May_Et_2014 <- Etosha_2014_Dry[months(Etosha_2014_Dry$timestamp) %in% month.name[5],]
Jun_Et_2014 <- Etosha_2014_Dry[months(Etosha_2014_Dry$timestamp) %in% month.name[6],]
Jul_Et_2014 <- Etosha_2014_Dry[months(Etosha_2014_Dry$timestamp) %in% month.name[7],]
Aug_Et_2014 <- Etosha_2014_Dry[months(Etosha_2014_Dry$timestamp) %in% month.name[8],]
Sep_Et_2014 <- Etosha_2014_Dry[months(Etosha_2014_Dry$timestamp) %in% month.name[9],]
Oct_Et_2014 <- Etosha_2014_Dry[months(Etosha_2014_Dry$timestamp) %in% month.name[10],]


head(May_Et_2014)
head(Jun_Et_2014)
head(Jul_Et_2014)
head(Aug_Et_2014)
head(Sep_Et_2014)
head(Oct_Et_2014)

t5 <- rbind(May_Et_2014, Jun_Et_2014)
t6 <- rbind(t5, Jul_Et_2014)
t7 <- rbind(t6, Aug_Et_2014)
t8 <- rbind(t7, Sep_Et_2014)
Dry_Etosha_2014 <- rbind(t8, Oct_Et_2014) 

Dry_Etosha_2014_New <- Dry_Etosha_2014[order(as.POSIXct(Dry_Etosha_2014$timestamp)),]
write.csv(Dry_Etosha_2014_New, "Dry_Etosha_2014.csv")





Nov_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[11],]
Dec_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[12],]
Jan_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[1],]
Feb_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[2],]
Mar_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[3],]
Apr_Et_2008 <- Etosha_2008[months(Etosha_2008$timestamp) %in% month.name[4],]

head(Nov_Et_2008)
head(Dec_Et_2008)
head(Jan_Et_2008)
head(Feb_Et_2008)
head(Mar_Et_2008)
head(Apr_Et_2008)

t1 <- rbind(Nov_Et_2008, Dec_Et_2008)
t2 <- rbind(t1, Jan_Et_2008)
t3 <- rbind(t2, Feb_Et_2008)
t4 <- rbind(t3, Mar_Et_2008)
Wet_Etosha_2008 <- t1

Wet_Etosha_2008_New <- Wet_Etosha_2008[order(as.POSIXct(Wet_Etosha_2008$timestamp)),]
str(Wet_Etosha_2008_New)

unique(Wet_Etosha_2008_New$timestamp)

write.csv(Wet_Etosha_2008_New, "Wet_Etosha_2008.csv")




May <- Etosha[months(Etosha$timestamp) %in% month.name[5],]
Jun <- Etosha[months(Etosha$timestamp) %in% month.name[6],]
Jul <- Etosha[months(Etosha$timestamp) %in% month.name[7],]
Aug <- Etosha[months(Etosha$timestamp) %in% month.name[8],]
Sep <- Etosha[months(Etosha$timestamp) %in% month.name[9],]
Oct <- Etosha[months(Etosha$timestamp) %in% month.name[10],]


head(May)
head(Jun)
head(Jul)
head(Aug)
head(Sep)
head(Oct)

t5 <- rbind(May, Jun)
t6 <- rbind(t5, Jul)
t7 <- rbind(t6, Aug)
t8 <- rbind(t7, Sep)
Dry <- rbind(t8, Oct) 

Dry <- Dry[order(as.POSIXct(Dry$timestamp)),]
write.csv(Dry, "Dry.csv")




unique(Dry$'individual-local-identifier')


Area <- "Etosha National Park, namibia"
ar <- geocode(Area)
qmap(Area, maprange = TRUE, zoom = 9,
     base_layer = ggplot(aes(x=lon, y=lat), data = ar)) +
  geom_point()



Etosha_Dry_Centroids <- structure(list(Latitude = c(), 
                                       Longitude = c()), class = "data.frame")

Etosha_Wet_Centroids <- list(Latitude = c(-19.199724, -19.195671, -19.193313, -19.183726, -19.220431, -19.204964, -19.213236, -19.199835, -19.210151, -19.202172, -19.196814, -19.277196, -19.114858, -19.130896, -19.172268), 
                                       Longitude = c(15.947975, 15.908201, 15.931699, 15.987589, 15.991655, 15.967243, 15.945382, 15.879534, 15.918596, 16.012633, 15.895480, 15.853614, 15.903159, 16.092815, 16.152980))




qmap(location = "Etosha National Park, namibia") + geom_point(aes(x = Data$Longitude, y = Data$Latitiude))
                       
where <- ""
wh <- geocode(where)
qmap(where, maprange = TRUE, zoom = 15,
     base_layer = ggplot(aes(x=lon, y=lat), data = wh)) +
  geom_point()









#Etosha Dry Centroids

#Etosha Wet Centroids


Eto_WET_lon <- c(15.947975, 15.908201, 15.931699, 15.987589, 15.991655, 15.967243, 15.945382, 15.879534, 15.918596, 16.012633, 15.895480, 15.853614, 15.903159, 16.092815, 16.152980)
Eto_WET_lat <- c(-19.199724, -19.195671, -19.193313, -19.183726, -19.220431, -19.204964, -19.213236, -19.199835, -19.210151, -19.202172, -19.196814, -19.277196, -19.114858, -19.130896, -19.172268)
df_Eto_Wet <- as.data.frame(cbind(Eto_WET_lon,Eto_WET_lat))

# getting the map
mapgilbert <- get_map(location = c(lon = mean(df_Eto_Wet$Eto_WET_lon), lat = mean(df_Eto_Wet$Eto_WET_lat)), zoom = 5,
                      maptype = "satellite", scale = "none")

# plotting the map with some points on it
ggmap(mapgilbert) +
  geom_point(data = df_Eto_Wet, aes(x = Eto_WET_lon, y = Eto_WET_lat, fill = "red", alpha = 0.8), size = 5, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)

