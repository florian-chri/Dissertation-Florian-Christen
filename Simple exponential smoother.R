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

tstrain <- ts(train$TotalRooms,frequency=365, start = decimal_date(ymd("2018-1-1")))
tstest <- ts(test$TotalRooms,frequency=365, start = decimal_date(ymd("2023-1-1")))

mape <- function(actual,pred){
  mape <- mean(abs((actual - pred)/actual))*100
  return(mape)
}


sv <- numeric()
sv[1] <- tstrain[1]

exponential_smoother <- function(alpha){
  for (x in 2:length(tstrain)){
    sv[x] <- alpha * tstrain[x] + (1-alpha) * sv[x-1]
  }
  return(sv)
}

plot(exponential_smoother(0), type='l', col='red')

plot(tstrain, type='l', col='grey')
lines(exponential_smoother(0.2), col='orange')


e_smoothed <- data.frame(0)

filter_degree <- seq(1,100, by=1)

for (y in seq(1,0.01, by=-0.01)){
  sm_va <- exponential_smoother(y)
  e_smoothed <- cbind(e_smoothed, data.frame=sm_va)
}

work1 <- e_smoothed[,-c(1)]
work1 <- work1 %>% replace(is.na(.), 0)
eststrain <- ts(work1, frequency=365, start = decimal_date(ymd("2018-1-1")))



ma_mape_values1 <- numeric()

for(i in 1:ncol(eststrain)) {
  ma1 <- ma(eststrain[ , i], order=8, centre = FALSE)
  mapred1 <- predict(ma1, h=365)
  mape <- mean(abs((tstest-mapred1$mean)/tstest)*100)

  ma_mape_values1[i] <- mape
}

plot(ma_mape_values1, type='l')
min(ma_mape_values1)
ma_mape_values1[1]
which.min(ma_mape_values1)

#ggplots
plot_df_ef <- data_frame(filter_degree,mape_valuestest,ma_mape_values1)
write.csv(plot_df_ef, file = 'C:/Users/Florian.Christen/Desktop/R Projects/ResultSES.csv')

ggplot(data = plot_df_ef)+
  geom_line(aes(x=filter_degree,y=mape_valuestest))

ggplot(data = plot_df_ef)+
  geom_line(aes(x=filter_degree,y=ma_mape_values1))


mape_valuestest <- numeric()

for(i in 1:ncol(eststrain)) {       # for-loop over columns
  
  testets1 <- ets(eststrain[ , i], model = "ANN")
  
  etspred1 <- predict(testets1,365) 
  
  mape <- mean(abs((tstest-etspred1$mean)/tstest)*100)
 
  mape_valuestest[i] <- mape
}
plot(mape_valuestest, type='l')

min(mape_valuestest)
which.min(mape_valuestest)
mape_valuestest[1]

plotesfc <- ma(eststrain[,61], order=8, centre = FALSE)
predesplot <- predict(plotesfc, h=365)
plot(tstest,type='l',col='grey', ylab='Rooms Sold')
lines(ts(predesplot$mean, frequency=365, start = decimal_date(ymd("2023-1-1"))), col='red')
