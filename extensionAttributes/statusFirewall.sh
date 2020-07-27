#!/bin/sh

fw=$(defaults read /Library/Preferences/com.apple.alf globalstate)

if [ "$fw" == 0 ]; then
echo "<result>Off</result>"
else
	echo "<result>On</result>"
fi
