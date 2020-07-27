#!/bin/sh

##############################################################################
# A script to retrieve the VirtualBox version being used by a machine.       #
# If no VirtualBox is found, "Not Installed" will return back.               #
##############################################################################
RESULT="Not Installed"
VB_VERSION=$(echo $(virtualbox --help | head -n 1 | awk '{print $NF}'))

if [ -n "$VB_VERSION" ] ; then
	RESULT=$(echo "$VB_VERSION" | cut -f2- -dv)
fi
echo "<result>$RESULT</result>"
exit 0
