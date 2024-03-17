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


masmoothed <- data.frame(0)

filter_degrees <- seq(1,200, by=1)

for (j in filter_degrees) {
  filter_degree <- filter_degrees[j]
  ts_smooth <- runner(tstrain, k=j, f=mean)
  masmoothed <- cbind(masmoothed, data.frame=ts_smooth)
}


work_ma <- masmoothed[,-c(1)]

matstrain <- ts(work_ma, frequency=365, start = decimal_date(ymd("2018-1-1")))

ma2_mape_values <- numeric()

for(i in 1:ncol(matstrain)) {
  ma2 <- ma(matstrain[ , i], order=8, centre = FALSE)
  mapred2 <- predict(ma2, h=365)
  mape <- mean(abs((tstest-mapred2$mean)/tstest)*100)

  ma2_mape_values[i] <- mape
}

plot(ma2_mape_values, type='l')
min(ma2_mape_values)
ma2_mape_values[1]
which.min(ma2_mape_values)




mape_valuestest2 <- numeric()

for(i in 1:ncol(matstrain)) {     
  
  testets2 <- ets(matstrain[ , i], model = "ANN")
  
  etspred2 <- predict(testets2,365) 
  
  mape <- mean(abs((tstest-etspred2$mean)/tstest)*100)
 
  mape_valuestest2[i] <- mape
}
plot(mape_valuestest2, type='l')

min(mape_valuestest2)
which.min(mape_valuestest2)
mape_valuestest2[1]

plot_df2 <-  data_frame(filter_degrees, ma2_mape_values, mape_valuestest2)
write.csv(plot_df2, file = 'C:/Users/Florian.Christen/Desktop/R Projects/ResultMA.csv')

ggplot(data = plot_df2)+
  geom_line(aes(x=filter_degrees,y=mape_valuestest2))

ggplot(data = plot_df2)+
  geom_line(aes(x=filter_degrees,y=ma2_mape_values))

plotmafc <- ma(matstrain[,2], order=8, centre = FALSE)
predmaplot <- predict(plotmafc, h=365)
plot(tstest,type='l',col='grey', ylab='Rooms Sold')
lines(ts(predmaplot$mean, frequency=365, start = decimal_date(ymd("2023-1-1"))), col='red')
