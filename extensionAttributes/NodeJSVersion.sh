#!/bin/sh

##############################################################################
# A script to collect the version of Node JS currently installed.            #
# If Node JS is not installed "Not Installed" will return back.              #
##############################################################################
RESULT="Not Installed"

if [ -f /usr/local/bin/node ]; then
	RESULT=$(/usr/local/bin/node --version | cut -f2- -dv)
fi

echo "<result>$RESULT</result>"
exit 0