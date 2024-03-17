setwd("C:/Users/Florian.Christen/Desktop/R Projects")
getwd()

library(tidyverse)
library(tidyquant)
library(fBasics)
library(forecast)
library(tsbox)
library(FKF)
library(runner)

PmsActualData <- read.csv("C:/Users/Florian.Christen/Desktop/R Projects/PmsActualDataRoomsSoldSegmented.csv", sep=";")

pivot <- PmsActualData %>% 
  select(BusinessDate,Amount,AccountOriginId)%>%
  group_by(AccountOriginId, BusinessDate)

pivot2 <- pivot[order(pivot$BusinessDate),] %>%
  pivot_wider(names_from = "AccountOriginId", values_from ="Amount")

pivot2 <- pivot2 %>% replace(is.na(.), 0)

pivot2$BusinessDate = as.Date(pivot2$BusinessDate, format = '%Y-%m-%d')

Year = lubridate::year(pivot2$BusinessDate)
Month = factor(month(pivot2$BusinessDate))
Day = day(pivot2$BusinessDate)
Weekday = factor((weekdays(pivot2$BusinessDate)), levels= c('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'))

attach(pivot2); TotalRooms <- Segment_CCO_RoomsSold+Segment_FIR_RoomsSold+Segment_GRU_RoomsSold+Segment_LMW_RoomsSold+
  Segment_LWE_RoomsSold+Segment_TAG_RoomsSold+Segment_MES_RoomsSold+Segment_COM_RoomsSold+Segment_GUT_RoomsSold+Segment_APT_RoomsSold+
  `Segment_**_RoomsSold`+Segment_BGR_RoomsSold+Segment_LIR_RoomsSold+Segment_LCO_RoomsSold+Segment_LGR_RoomsSold+Segment_AIN_RoomsSold+
  Segment_MGR_RoomsSold+Segment_MIN_RoomsSold;detach(pivot2)

attach(pivot2);OTBData <- data.frame(BusinessDate,Year,Month,Day,Weekday,TotalRooms);detach(pivot2)

plot(OTBData$BusinessDate, OTBData$TotalRooms, type='l')

cutoff <- head(OTBData, n=1945)
train <- head(cutoff, n=1580)
test <- tail(cutoff, n=365)
test1 <- head(test, n=100)

tstrain <- ts(train$TotalRooms,frequency=365, start = decimal_date(ymd("2018-1-1")))
tstest <- ts(test$TotalRooms,frequency=365, start = decimal_date(ymd("2023-1-1")))
tstest1 <- ts(test1$TotalRooms,frequency=365, start = decimal_date(ymd("2023-1-1")))

plot(tstrain, ylab='Rooms Sold', xlab='Time')


mape <- function(actual,pred){
  mape <- mean(abs((actual - pred)/actual))*100
  return(mape)
}

n <- length(tstrain)
observed_values <- tstrain
q_values <- seq(0.1,0.0001, by=-0.0005)

# Kalman Filter

kalman_smooth <- function(rooms, Q=i , R = 0.01) {
  n <- length(rooms)
  
  # Initialisierung
  x_hat <- rep(0, n)
  P <- rep(1, n)
  
  # Kalman Filter Parameter
  F <- 1
  H <- 1
  I <- 1
  
  smoothed_values <- rep(0, n)
  
  for (k in 2:n) {
    # Prediction
    x_hat_pred <- F * x_hat[k - 1]
    P_pred <- F * P[k - 1] * F + Q
    
    # Update
    K <- P_pred * H / (H * P_pred * H + R)
    x_hat[k] <- x_hat_pred + K * (rooms[k] - H * x_hat_pred)
    P[k] <- (I - K * H) * P_pred
    
    # Werte in Verktor speichern
    smoothed_values[k] <- x_hat[k]
    }
  return(smoothed_values)
  }

k_smoothed <- data.frame(0)

for (i in q_values){

smoothed_values <- kalman_smooth(observed_values, Q=i)
k_smoothed <- cbind(k_smoothed, data.frame=smoothed_values)

}
work <- k_smoothed[,-c(1)]

mtstrain <- ts(work, frequency=365, start = decimal_date(ymd("2018-1-1")))

filter_degrees <- seq(1,200, by=1)

plot_df <- data_frame(filter_degrees,mape_values,ma_mape_values)
write.csv(plot_df, file = 'C:/Users/Florian.Christen/Desktop/R Projects/ResultKalman.csv')

ggplot(data = plot_df)+
  geom_line(aes(x=filter_degrees,y=mape_values))

ggplot(data = plot_df)+
  geom_line(aes(x=filter_degrees,y=ma_mape_values))


plot(mtstrain[,41])
plot(mtstrain[,101])
plot(mtstrain[,181])
plot(mtstrain[,200])


test <- HoltWinters(tstrain)
pred_test <- predict(test, 365)
mape <- mean(abs((tstest-pred_test)/tstest)*100);mape


test_ma <- ma(tstrain, order=8, centre=FALSE)
test_ma_pred <- predict(test_ma, h=365)
mape <- mean(abs((tstest-test_ma_pred$mean)/tstest)*100);mape

print(mape_values)
plot(mape_values, type='l')
which.min(mape_values)
min(mape_values)
mape_values[length(q_values)]

ma_mape_values <- numeric()
#MA Forecasting
for(i in 1:ncol(mtstrain)) {
  ma <- ma(mtstrain[ , i], order=8, centre = FALSE)
  mapred <- predict(ma, h=365)
  mape <- mean(abs((tstest-mapred$mean)/tstest)*100)
  # MAPE in Vektor speichern
  ma_mape_values[i] <- mape
}

plot(ma_mape_values, type='l')
which.min(ma_mape_values)
min(ma_mape_values)
ma_mape_values[length(q_values)]

plotfc <- ma(mtstrain[,197], order=8, centre = FALSE)
predplot <- predict(plotfc, h=365)
plot(tstest,type='l',col='grey', ylab='Rooms Sold')
lines(ts(predplot$mean, frequency=365, start = decimal_date(ymd("2023-1-1"))), col='red')

mape_values <- numeric()

for(i in 1:ncol(mtstrain)) {
  
  testets <- ets(mtstrain[ , i], model = "ANN")
  
  etspred <- predict(testets,365) 
  
  mape <- mean(abs((tstest-etspred$mean)/tstest)*100)
 #Mape speichern
  mape_values[i] <- mape
}
plot(mape_values, type='l')

min(mape_values)
which.min(mape_values)
mape_values[1]

testets <- ets(tstrain, model = "ANN")

etspred <- predict(testets,365) 

mape <- mean(abs((tstest-etspred$mean)/tstest)*100)
mape
