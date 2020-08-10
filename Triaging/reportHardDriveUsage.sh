#!/bin/sh
####################################################################################################
#
# ABOUT
#
#   Disk Usage: Home Directory
#
####################################################################################################
#
# HISTORY
#
#   Version 1.0, 8-Dec-2014, Dan K. Snelson
#   Version 1.1, 8-Jun-2015, Dan K. Snelson
#       See: https://jamfnation.jamfsoftware.com/discussion.html?id=14701
#   Version 1.2, 4-Jan-2017, Dan K. Snelson
#       Updated for macOS 10.12
#
####################################################################################################
# Import logging functions
#source /path/to/client-side/logging/script/logging.sh
####################################################################################################


# Variables
loggedInUser=$(/usr/bin/stat -f%Su /dev/console)
loggedInUserHome=$(/usr/bin/dscl . -read /Users/$loggedInUser NFSHomeDirectory | /usr/bin/awk '{print $NF}') # mm2270
machineName=$(/usr/sbin/scutil --get LocalHostName)
volumeName=$(/usr/sbin/diskutil info / | grep "Volume Name:" | awk '{print $3,$4}')

osMinorVersion=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d. -f2)

	if [[ "$osMinorVersion" -lt 12 ]]; then
		availableSpace=$(/usr/sbin/diskutil info / | grep "Volume Free Space:" | awk '{print $4}')
		totalSpace=$(/usr/sbin/diskutil info / | grep "Total Size:" | awk '{print $3}')
	else
		availableSpace=$(/usr/sbin/diskutil info / | grep "Volume Available Space:" | awk '{print $4}')
		totalSpace=$(/usr/sbin/diskutil info / | grep "Volume Total Space:" | awk '{print $4}')
	fi

percentageAvailable=$(/bin/echo "scale=1; ($availableSpace / $totalSpace) * 100" | bc)
outputFileName="$loggedInUserHome/Desktop/$loggedInUser-DiskUsage.txt"


# Output to log
ScriptLog "### Disk usage for \"$loggedInUserHome\" ###"
ScriptLog "* Available Space:  $availableSpace GB"
ScriptLog "* Total Space:      $totalSpace GB"
ScriptLog "* Percentage Free:  $percentageAvailable%"


# Output to user
/bin/echo "--------------------------------------------------" > $outputFileName
/bin/echo "`now` Disk usage for \"$loggedInUserHome\"" >> $outputFileName
/bin/echo "* Available Space:  $availableSpace GB" >> $outputFileName
/bin/echo "* Total Space:      $totalSpace GB" >> $outputFileName
/bin/echo "* Percentage Free:  $percentageAvailable%" >> $outputFileName
/bin/echo "--------------------------------------------------" >> $outputFileName
/bin/echo " " >> $outputFileName
/bin/echo "GBs Directory or File" >> $outputFileName
/bin/echo " " >> $outputFileName
#/usr/bin/du -axrg / | /usr/bin/sort -nr | /usr/bin/head -n 75 >> $outputFileName
/usr/bin/du -axrg $loggedInUserHome | /usr/bin/sort -nr | /usr/bin/head -n 75 >> $outputFileName


if [ -f $outputFileName ]; then
	/usr/bin/su - $loggedInUser -c "open -a google chrome $outputFileName"
fi

exit 0      ## Success
exit 1      ## Failure