#!/bin/sh
##############################################################################
# A script to show avialble software updates.                          		 #
# If no macOS updates are avilable, "No Updates Available" will return back. #
##############################################################################

RESULT="No Updates Available"

if [ -f "softwareupdate -l | grep "*" | sed "s/\*//g" | sed "s/$/,/g"" ]; then
	RESULT=$(softwareupdate -l | grep "*" | sed "s/\*//g" | sed "s/$/,/g")
fi
echo "<result>$RESULT</result>"
exit 0
