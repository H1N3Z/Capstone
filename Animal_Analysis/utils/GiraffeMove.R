library(xlsx)

########
# DATA #
########

data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//Giraffe//Giraffe.csv")
head(data)

F2 <- filter(data, ID == "F2")

unique(data$ID)

head(F2)



# Elevation change over time like distance vs time
# Do transition probability vs elevation co-variate







