#Author: N'Dea Jackson
#Assignment: Final Project
#Date: November 11, 2020

#Install Libraries
library(RColorBrewer)
library(lattice)
library(maps)
library(ggmap)
library(ggplot2)
devtools::install_github("dkahle/ggmap", ref = "tidyup", force=TRUE)


#Load Data
BOScrimeCSV <- file.choose()
BOScrime <- read.csv(file = BOScrimeCSV, header = TRUE)
View(BOScrime)

###### DATA CLEANING ######
#Remove shooting column (empty)
BOScrime <- BOScrime[ ,-7]

#Check the dimensions of the data set
dim(BOScrime)

#Check for empty values
nrow(is.na(BOScrime))

sort(unique(BOScrime$DISTRICT))

#Generate some plots
barplot(table(BOScrime$DISTRICT), main = "Distribution of Crime by District",
        xlab = "District", ylab = "Frequency", col = c("#B60009", "#07237D"), ylim = c(0,50000))


pie(table(BOScrime$YEAR), main = "Distribution of Crime by Year",
         col = c("#B60009", "#07237D"), labels())

barplot(table(BOScrime$MONTH), main = "Distribution of Crime by Month",
        xlab = "Month", ylab = "Frequency", col = c("#B60009", "#07237D"), ylim = c(0,35000))

barplot(table(BOScrime$OFFENSE_CODE_GROUP), main = "Distribution of Crime by Month",
        xlab = "Month", ylab = "Frequency", col = c("#B60009", "#07237D"), ylim = c(0,35000))


barplot(mostFreq, main = "Top 10 Most Frequent Crimes",
        xlab = "Crime", ylab = "Frequency", col = c("#B60009", "#07237D"), ylim = c(0,40000),
        las = 3)

barplot(table(BOScrime$HOUR), main = "Distribution of Crime by Hour of Day",
        xlab = "Hour", ylab = "Frequency", col = c("#B60009", "#07237D"), ylim = c(0,25000), xlim = c(0,25),
        las = 3)

hist(BOScrime$HOUR, main = "Distribution of Crime by Hour of Day",
        xlab = "Hour", ylab = "Frequency", col = c("#B60009", "#07237D"), ylim = c(0,25000), xlim = c(0,25),
        las = 3)

polygon(BOScrime$HOUR)

densBOS <- density(BOScrime$HOUR)
plot(densBOS)

plot(densBOS, type="n", main = "DISTRIBUTION OF CRIME BY HOUR OF DAY")
polygon(densBOS, col="gray", border="dimgray")

#Create a table of hour data
sort(table(BOScrime$HOUR))

#Identify the unique offense code groups
unique(BOScrime$OFFENSE_CODE_GROUP)

#Identify the most frequent crimes
BOScrimeTab <- table(BOScrime$OFFENSE_CODE_GROUP)
mostFreq <- BOScrimeTab[BOScrimeTab > 10000]
sort(mostFreq)



#YAY More plots
barplot(sort(table(BOScrime$DAY_OF_WEEK)), main = "Distribution of Crime by Day of Week",
        xlab = "Day", ylab = "Frequency", col = "gray48", ylim = c(0,50000))

#Begin Map Data
mapBos <- map_data("state", region="massachusetts") 

ggplot(mapBos, aes(x=long, y=lat))+geom_polygon()

ggmap(get_map(location = 'Boston', zoom = 7)) +
  geom_point(data=salesCalls, aes(x=lon, y=lat, size=Calls), color="orange")


map_sf <- get_map('Boston', zoom = 12, maptype = 'satellite')
ggmap(map_sf)

register_google(key = "AIzaSyDM4ProETxbQT-V66ws4CEXGpuv_be12d4")
ggmap::register_google(key = "AIzaSyDM4ProETxbQT-V66ws4CEXGpuv_be12d4")

get_map(location = "texas", zoom = 10, source = "google")


get_googlemap("boston, massachusetts") %>% ggmap()

bosStreet <- data.frame(BOScrime$Location)
require(stringr)

regex <-"\\((\\d+\\.\\d+), (-\\d+\\.\\d+)\\)"
lat_long <- str_match(BOScrime$Location, regex)[,2:3]
lat_long <- apply(lat_long, 2, as.numeric)
colnames(lat_long) <- c("y", "x")
crime_latlong <- cbind(BOScrime, lat_long)
head(lat_long) #much better



require(ggmap)
map.center <- geocode("Boston, MA")
Bos_map <- qmap(c(lon=map.center$lon, lat=map.center$lat), zoom=12)

top_crimes <- crime_latlong[crime_latlong$OFFENSE_CODE_GROUP == "Motor Vehicle Accident Response",]
top_crimes2 <- crime_latlong[crime_latlong$OFFENSE_CODE_GROUP == "Larceny",]
top_crimes3 <- crime_latlong[crime_latlong$OFFENSE_CODE_GROUP == "Medical Assistance",]


g <- Bos_map + geom_point(aes(x=x, y=y), data=top_crimes, size=3, alpha=0.2, color="red") + 
  ggtitle("Drug Charges in Boston by Location (2011-2014)") + 
  geom_point(aes(x=x, y=y), data=top_crimes2, size=3, alpha=0.2, color="blue") + 
  geom_point(aes(x=x, y=y), data=top_crimes3, size=3, alpha=0.2, color="gray")

g1 <- Bos_map + geom_point(aes(x=x, y=y), data=top_crimes, size=3, alpha=0.1, color="red") + 
  ggtitle("Motor Vehicle Accident Response in Boston by Location (2015-2018)")
g2 <- Bos_map + geom_point(aes(x=x, y=y), data=top_crimes2, size=3, alpha=0.1, color="blue") + 
  ggtitle("Larceny in Boston by Location (2015-2018)")
g3 <- Bos_map + geom_point(aes(x=x, y=y), data=top_crimes3, size=3, alpha=0.1, color="deepskyblue3") + 
  ggtitle("Medical Assistance Calls in Boston by Location (2015-2018)")




BostonMap=ggmap(get_map("Boston",
                         zoom=12,
                         source="google",
                         maptype="terrain"))

#Create New DataTable for Crime Locations————–
Boston1 = data.frame(BOScrime$Long, BOScrime$Lat)
colnames(Boston1) = c("lon","lat")

# Plot heatmap of crimes——————————————-

BostonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level..,alpha=..level..), bins = 10, geom = "polygon", data = Boston1) +
  scale_fill_gradient(low = "blue", high = "red")+
  ggtitle("Map of Crime Density in Boston")


Boston2 = data.frame(BOScrime$Long, BOScrime$Lat, BOScrime$OFFENSE_CODE_GROUP)[BOScrime$OFFENSE_CODE_GROUP == "Motor Vehicle Accident Response",]
colnames(Boston2) = c("lon","lat")
BostonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level..,alpha=..level..), bins = 10, geom = "polygon", data = Boston2) +
  scale_fill_gradient(low = "blue", high = "red")+
  ggtitle("Motor Vehicle Accident Response Density in Boston")


Boston3 = data.frame(BOScrime$Long, BOScrime$Lat, BOScrime$OFFENSE_CODE_GROUP)[BOScrime$OFFENSE_CODE_GROUP == "Larceny",]
colnames(Boston3) = c("lon","lat")
BostonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level..), bins = 10, geom = "polygon", data = Boston3) +
  scale_fill_gradient(low = "blue", high = "red")+
  ggtitle("Larceny Density in Boston")


Boston4 = data.frame(BOScrime$Long, BOScrime$Lat, BOScrime$OFFENSE_CODE_GROUP)[BOScrime$OFFENSE_CODE_GROUP == "Medical Assistance",]
colnames(Boston4) = c("lon","lat")
BostonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level..,alpha=..level..), bins = 10, geom = "polygon", data = Boston4) +
  scale_fill_gradient(low = "blue", high = "red")+
  ggtitle("Medical Assistance Density in Boston")


Boston5 = data.frame(BOScrime$Long, BOScrime$Lat, BOScrime$OFFENSE_CODE_GROUP)[BOScrime$OFFENSE_CODE_GROUP == "Investigate Person",]
colnames(Boston5) = c("lon","lat")
BostonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level..,alpha=..level..), bins = 10, geom = "polygon", data = Boston5) +
  scale_fill_gradient(low = "blue", high = "red")+
  ggtitle("Investigate Person Requests Density in Boston")








#Created a test data set so that I didn't mess anything up
tst <- aggregate(BOScrime$MONTH, list(BOScrime$DAY_OF_WEEK, BOScrime$MONTH), range)
tapply(df$time, list(df$status), range)
aggregate(df$time, list(df$status, df$sex), mean)

barplot(tst, beside = TRUE)

#Fix bar graph so that days of the week are in order
str(BOScrime)
BOScrime$MONTH <- as.factor(BOScrime$MONTH)
BOScrime$YEAR <- as.factor(BOScrime$YEAR)
BOScrime$HOUR <- as.factor(BOScrime$HOUR)
BOScrime$OFFENSE_CODE <- as.factor(BOScrime$OFFENSE_CODE)
BOScrime$DISTRICT <- as.factor(BOScrime$DISTRICT)
BOScrime$DAY_OF_WEEK <- as.factor(BOScrime$DAY_OF_WEEK)

ggplot(BOScrime, aes(x = c(MONTH, DAY_OF_WEEK)))

barplot(table(BOScrime$DAY_OF_WEEK, BOScrime$MONTH), beside = T)

table(BOScrime$DAY_OF_WEEK, BOScrime$MONTH)

dfDate <- data.frame(table(BOScrime$DAY_OF_WEEK, BOScrime$MONTH))
colnames(dfDate) = c("DOW","Month", "Freq")


order_wk <- c("Sunday","Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

freqtab <- table(BOScrime$DAY_OF_WEEK, BOScrime$MONTH)
freqt[order_wk]



BOScrime$DAY_OF_WEEK <- as.factor(BOScrime$DAY_OF_WEEK)
str(BOScrime$DAY_OF_WEEK)

BOScrime$DAY_OF_WEEK[1]
BOScrime$DAY_OF_WEEK[2] #<- "Monday"
BOScrime$DAY_OF_WEEK[3] #<- "Tuesday"
BOScrime$DAY_OF_WEEK[4] #<- "Wednesday"
BOScrime$DAY_OF_WEEK[5] #<- "Thursday"
BOScrime$DAY_OF_WEEK[6] #<- "Friday"
BOScrime$DAY_OF_WEEK[7] #<- "Saturday"


boscrimetst <- BOScrime
boscrimetst$DAY_OF_WEEK <- factor(boscrimetst$DAY_OF_WEEK, levels = c("Sunday", "Monday", "Tuesday", 
                                          "Wednesday", "Thursday", "Friday", "Saturday"), ordered = T)
levels(boscrimetst$DAY_OF_WEEK)

max(table(BOScrime$DAY_OF_WEEK))

par(mfrow = c(2,1))

barplot(table(boscrimetst$DAY_OF_WEEK, boscrimetst$MONTH), beside = T,
        xlab = "Month", ylab = "Frequency", main = "Crime Frequency by Month and Day of Week",
        ylim = c(0,6000))


BOScrime$DAY_OF_WEEK <- factor(BOScrime$DAY_OF_WEEK, levels = c("Sunday", "Monday", "Tuesday", 
                                                                      "Wednesday", "Thursday", "Friday", "Saturday"), ordered = T)
levels(BOScrime$DAY_OF_WEEK)

#Month and Day of Week Bar plots
barplot(table(BOScrime$DAY_OF_WEEK, BOScrime$MONTH), beside = T,
        xlab = "Month", ylab = "Frequency", main = "Crime Frequency by Month and Day of Week",
        ylim = c(0,6000))


table(BOScrime$DAY_OF_WEEK)


boxplot(BOScrime$MONTH)

table(BOScrime$MONTH)

#Generate a word cloud
library(wordcloud)
library(tm)
library(RColorBrewer)
install.packages("wordcloud2")
library(wordcloud2)
offenseText <- BOScrime$OFFENSE_CODE_GROUP

#Create a Corpus
offenseDoc <- Corpus(VectorSource(offenseText))
dtm <- TermDocumentMatrix(offenseDoc)
offenseMat <- as.matrix(dtm)
offenseWords <- sort(rowSums(offenseMat), decreasing = T)
offenseDF <- data.frame(word = names(offenseWords), freq = offenseWords)

wordcloud(words = offenseDF$word, freq = offenseDF$freq, min.freq = 1,
          max.words = 200, random.order = F, rot.per = 0.35, col = brewer.pal(n = 4, name = "Greys"))
par(bg = "black")

wordcloud2(offenseDF, color = "red")
par(bg = "black")


pie(BOScrime$DISTRICT)
distData <- BOScrime$DISTRICT
table(BOScrime$DISTRICT)
distData[distData == ""] <- "unknown"


pie(100 * round(table(distData)/sum(table(distData)), 4), col = c("gray", "firebrick1", "blue"),
    main = "Crimes by Police District")

#Exploding pie chart
library(plotrix)
slices <- (100 * round(table(distData)/sum(table(distData)), 4))
lbls <- c("A1", "A15", "A7", "B2", "B3", "C11", "C6", "D14", "E13", "E18", "E5", "unspecified")
pie3D(slices, labels = lbls, explode=0.1,
      main="Pie Chart of Countries ", col = c("gray", "firebrick1", "blue"))



plot(table(BOScrime$YEAR), type="l",
     xlab="Year", ylab="Population", col = "gray", main = "Crime Rates by Year")


table(BOScrime$YEAR)

dim(BOScrime)
