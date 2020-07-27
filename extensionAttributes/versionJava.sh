#!/bin/sh
##############################################################################
# A script to collect the version of Java currently installed.               #
# If Java is not installed "Not Installed" will return back.                 #
##############################################################################

RESULT="Not Installed"


if [ -f "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Enabled.plist" ] ; then
	RESULT=$( defaults read "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Enabled.plist" CFBundleVersion )
fi
echo "<result>$RESULT</result>"
exit 0
