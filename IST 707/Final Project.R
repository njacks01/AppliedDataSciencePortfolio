library(readr)
library(dplyr) 
library(tidyr) 
library(hms) 
require(devtools)
install_version("nbastatR", repos = "http://cran.us.r-project.org")
library(nbastatR) 
library(sqldf)
library("arules")
library("arulesViz")

library(ggplot2)
NBA <- read.csv("~/Desktop/dataset1.csv")
View(NBA)

length(which(is.na(NBA)))
summary(NBA)
str(NBA)

NBA$LOCATION <- as.factor(NBA$LOCATION)
NBA$W <- as.factor(NBA$W)
NBA$PERIOD <- as.factor(NBA$PERIOD)
NBA$PTS_TYPE <- as.factor(NBA$PTS_TYPE)
NBA$SHOT_RESULT <- as.factor(NBA$SHOT_RESULT)
NBA$CLOSEST_DEFENDER <- as.factor(NBA$CLOSEST_DEFENDER)
NBA$CLOSEST_DEFENDER_PLAYER_ID <- as.factor(NBA$CLOSEST_DEFENDER_PLAYER_ID)
NBA$FGM <- as.factor(NBA$FGM)
NBA$player_name <- as.factor(NBA$player_name)
NBA$player_id <- as.factor(NBA$player_id)
NBA$date <- as.factor(NBA$date)
NBA$team <- as.factor(NBA$team)
NBA$opponent <- as.factor(NBA$opponent)
NBA$GAME_ID <- as.factor(NBA$GAME_ID)
NBA$FINAL_MARGIN <- as.factor(NBA$FINAL_MARGIN)
NBA$SHOT_NUMBER <- as.factor(NBA$SHOT_NUMBER)
NBA$DRIBBLES <- as.factor(NBA$DRIBBLES)
NBA$PTS <- as.factor(NBA$PTS)
NBA$yearSeason <- as.factor(NBA$yearSeason)
NBA$slugSeason <- as.factor(NBA$slugSeason)
NBA$idTeam <- as.factor(NBA$idTeam)
NBA$isShotMade <- as.factor(NBA$isShotMade)
#Remove Column
NBA <- NBA[,-27]
NBA$namePlayer <- as.factor(NBA$namePlayer)
NBA$nameTeam <- as.factor(NBA$nameTeam)
NBA$typeEvent <- as.factor(NBA$typeEvent)
NBA$typeAction <- as.factor(NBA$typeAction)
NBA <- NBA[,-31]
#Delete Redundant Date Column
NBA <- NBA[,-31]
NBA <- NBA[,-34]

length(unique(NBA$player_id))

length(unique(NBA$MATCHUP))

plot(NBA$PERIOD)

plot(NBA$typeAction)

table(NBA$W, NBA$FINAL_MARGIN)

hist(NBA$W, NBA$FINAL_MARGIN)

hist(table(NBA$SHOT_DIST, NBA$PTS_TYPE))

table(NBA$player_name, NBA$PTS)
hist(table(NBA$player_name, NBA$PTS))

hist(NBA$PTS_TYPE)

#Visualizations
ggplot(NBA, aes(x = PTS_TYPE, y = SHOT_RESULT, fill = SHOT_RESULT)) +
  geom_bar(stat = "identity") + labs(x = "Points Type", y = "Shot Result", fill = "Shot Result") +
  ggtitle("Points Type vs. Shot Result")

ggplot(NBA, aes(x = W, y = length(GAME_ID), fill = W)) +
  geom_bar(stat = "identity") + labs(x = "Points Type", y = "Shot Result", fill = "Shot Result") +
  ggtitle("Points Type vs. Shot Result")

table(NBA$W, NBA$SHOT_RESULT, NBA$PTS_TYPE)
table(NBA$W, NBA$PTS_TYPE)

NBATest <- NBA

hist(NBA$TOUCH_TIME)

#Discretization
range(NBA$SHOT_DIST)
range(NBA$shotclock)
range(NBA$TOUCH_TIME)
range(NBA$SHOT_DIST)
range(NBA$CLOSE_DEF_DIST)

NBA$shotclock <- cut(NBA$shotclock, breaks = c(-Inf, 5.0, 10.0, 15.0, 20.0, Inf), 
                    labels = c("Buzzer Beater", "Under 10 Seconds", "Under 15 Seconds", "Under 20 Seconds", "Full Clock"))

NBA$SHOT_DIST <- cut(NBA$SHOT_DIST, breaks = c(-Inf, 15.0, 30.0, 45, Inf),
                     labels = c("Short Range", "Mid Range", "Long Range", "Mid-Court"))

NBA$CLOSE_DEF_DIST <- cut(NBA$CLOSE_DEF_DIST, breaks = c(-Inf, 15, 30, 45, Inf),
                      labels = c("Very Close", "Close", "Farther Out", "Not Closely Guarded"))

NBA$secondsRemaining <- cut(NBA$secondsRemaining, breaks = c(-Inf, 10, 20, 30, 40, 50, Inf),
                      labels = c("End Quarter", "Under 20 Seconds", "Under 30 Seconds", "Under 40 Seconds", "Under 50 Seconds", "Under 1 Minute"))

#Association Rule Mining
NBArules <- apriori(NBA, parameter = list(supp = 0.25, conf=0.7))
summary(NBArules)
inspect(NBArules[1:10])

NBARM <- apriori(NBATest, parameter = list(supp = 0.25, conf=0.7))
summary(NBARM)

inspect(NBARM[1:20])
NBARM <- sort(NBARM, decreasing = TRUE, by = "lift")
NBARM <- sort(NBARM, decreasing = TRUE, by = "confidence")


NBATest <- NBA
NBATest <- NBATest[, -35]
NBATest$distanceShot <- as.factor(NBATest$distanceShot)
NBATest$zoneRange <- as.factor(NBATest$zoneRange)
NBATest$slugZone <- as.factor(NBATest$slugZone)
NBATest$nameZone <- as.factor(NBATest$nameZone)
NBATest$zoneBasic <- as.factor(NBATest$zoneBasic)
NBATest$minutesRemaining <- as.factor(NBATest$minutesRemaining)
NBATest$idEvent <- as.factor(NBATest$idEvent)
NBATest$slugTeamAway <- as.factor(NBATest$slugTeamAway)
NBATest$slugTeamHome <- as.factor(NBATest$slugTeamHome)
NBATest$gameclock <- as.factor(NBATest$gameclock)
NBATest$TOUCH_TIME <- as.factor(NBATest$TOUCH_TIME)


#Converting "YES" to "[variable_name] = YES
NBA$W = dplyr::recode(NBA$W, W = "W=W", L = "W=L")
NBA$SHOT_RESULT = dplyr::recode(NBA$SHOT_RESULT, YES = "SHOT_RESULT = made", NO = "SHOT_RESULT=missed")
NBATest$isShotMade = dplyr::recode(NBATest$isShotMade, YES = "isShotMade= TRUE", NO = "isShotMade= FALSE")

#Converting "YES" to "[variable_name] = YES
NBATest$W = dplyr::recode(NBATest$W, W = "W=W", L = "W=L")
NBATest$SHOT_RESULT = dplyr::recode(NBATest$SHOT_RESULT, made = "SHOT_RESULT=made", missed = "SHOT_RESULT=missed")



NBArulesTest <- apriori(NBATest, parameter = list(conf = 0.08, supp = 0.001, maxlen=15), appearance = list(rhs = c("W=W")))
summary(NBArulesTest)
NBArulesTest <- sort(NBArulesTest, decreasing = TRUE, by = "confidence")
inspect(NBArulesTest[1:20])
inspect(NBArulesTest[20:40])


NBArulesTest1 <- apriori(NBATest, parameter = list(conf = 0.05, supp = 0.001, maxlen=15), appearance = list(rhs = c("SHOT_RESULT=missed")))
summary(NBArulesTest1)
NBArulesTest1 <- sort(NBArulesTest1, decreasing = TRUE, by = "confidence")
inspect(NBArulesTest1[1:20])
inspect(NBArulesTest1[60:120])


NBArulesTest2 <- apriori(NBATest, parameter = list(conf = 0.8, supp = 0.001, maxlen=15), appearance = list(rhs = c("SHOT_RESULT=made")))
summary(NBArulesTest2)
NBArulesTest2 <- sort(NBArulesTest2, decreasing = TRUE, by = "confidence")
inspect(NBArulesTest2[1:20])
inspect(NBArulesTest2[20:40])


plot(NBArulesTest1[1:20], method = "graph")
plot(NBArulesTest2[1:20], method = "graph")


str(NBATest)

NBATest <- NBATest[, -18]
NBATest <- NBATest[, -27]
NBATest <- NBATest[, -35]
NBATest <- NBATest[, -35]
NBATest <- NBATest[, -7]
