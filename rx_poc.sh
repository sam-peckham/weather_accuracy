#! /bin/bash

# creates file name for raw data with today's date
today=$(date +%Y-%m-%d)
weather_report=raw_data_$today

city=seattle

# pulls current temperature and time from wttr.in for specified city. 
# saves in raw_data_[today's date].txt

curl wttr.in/$city --output $weather_report
# curl wttr.in/$city?format="%t\n%T\n" --output $weather_report

# find temperature and saves into temperature.txt
grep °F $weather_report > temperature.txt 

# find the observed temperature for today
obs_temp=$(grep °F $weather_report | head -1 | cut -d "[" -f4 | cut -d "+" -f2)
echo "The current temperature in $city: $obs_temp"

# find the forecasted temperature for tomorrow at noon
fc_temp=$(grep °F $weather_report | head -3 | tail -1 | cut -d "[" -f4 | cut -d "+" -f2)
echo "The forecast for tomorrow in $city: $fc_temp"

# creates variables for the hour, date, month, and year of when shell executed
time_zone='LosAngeles/PST'
hour=$(TZ=$time_zone date -u +%H)
date=$(TZ=$time_zone date -u +%d)
month=$(TZ=$time_zone date +%m)
year=$(TZ=$time_zone date +%Y)

record=$(echo -e "$year\t$month\t$date\t$obs_temp\t$fc_temp")
echo $record >> rx_poc.log
