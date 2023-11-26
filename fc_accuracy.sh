#! /bin/bash

# reads today's temperature and tomorrow's predicted temperature
today_temp=$(tail -1 rx_poc.log | cut -d " " -f3)
yesterday_fc=$(tail -2 rx_poc.log | head -1 | cut -d " " -f4 | cut -d '\' -f1)
#echo "Today's was forecasted to be $yesterday_fc  and the observed temp is $today_temp"
echo $today_temp

# determine difference between forecasted and observed
forecast_accuracy=$(($yesterday_fc-$today_temp))
#echo "The difference between forecasted and actual temperature is $fc_accuracy"

# take absolute value of the forecast difference
if $forecast_accuracy<0;
then
$forecast_accuracy=$forecast_accuracy*-1
fi

# assigns accuracy label to forecast accuracy
if [$forecast_accuracy<1]
then
    accuracy_label="Excellent"
elif [$forecast_accuracy<2]
then 
    accuracy_label="Good"
elif [$forecast_accuracy<3]
then
    accuracy_label="Fair"
else
    accuracy_label="Poor"
fi

# Derives metadata from rx_poc.log file
row=$(tail -1 rx_poc.log)
year=$( echo $row | cut -d " " -f1)
month=$( echo $row | cut -d " " -f2)
day=$( echo $row | cut -d " " -f3)

# Saves pertinent data in tsv file
echo -e "$year\t$month\t$day\t$today_temp\t$yesterday_fc\t$forecast_accuracy\t$accuracy_label" >> historical_fc_accuracy.tsv