#!/bin/sh

adminID=`dscl . -read /Users/fv2test UniqueID | awk '{print $2}'`

if [ $adminID -gt "500" ];then
dscl . -change /Users/fv2test UniqueID $adminID 101
chown -R fv2test /var/fv2test
defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool YES
else
echo "UniqueID is below 500"
fi
