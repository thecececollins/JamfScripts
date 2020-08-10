#!/bin/bash

##############################################################################
# A script to retrieve the Git version being used by a machine.              #
# If no Git is found, "Not Installed" will return back.                      #
##############################################################################
RESULT="Not Installed"
GIT_VERSION=$(/usr/local/bin/git version)
GIT=$(echo "$GIT_VERSION" | sed -n -e 's/^.*git version//p')



if [ -n "$GIT_VERSION" ] ; then
	RESULT=$(echo "$GIT_VERSION" | sed -n -e 's/^.*git version //p')
fi
echo "<result>$RESULT</result>"
exit 0