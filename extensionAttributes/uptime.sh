#!/bin/sh
##########################################################################
# A script to collect how many days a computer has been powered on.      #
##########################################################################


RESULT=$( uptime | awk -F "(up | days)" '{ print $2 }' )

if ! [ "$RESULT" -eq "$RESULT" ] 2> /dev/null ; then
	dayCount="0"
fi

echo "<result>$RESULT Days</result>"

exit 0
