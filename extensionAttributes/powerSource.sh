#!/bin/bash
###########################################
# Check to see where power 
# is drawing on system
# 'Battery Power' vs. 'AC Power'
###########################################
# by Christopher Miller 
# for ITSD-ISS of JHU-APL
# Dated: 2016-05-24, last Mod: 
# Cobbled together from other's hard work
###########################################

#Use the power management to check 
PowerUP=$(pmset -g batt | head -n 1)

#Find the time this was checked
ShotTime=$(/bin/date)

#Put it together
result=$(echo "$PowerUP" on "$ShotTime")

echo "<result>$result</result>"

exit 0 
