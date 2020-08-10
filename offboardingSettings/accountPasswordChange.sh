#!/bin/sh
# This script will be used by offboarding employees to change their user account password to our IT managed password. This should help prevent us from running into issues when we try to archive the machine.


# Variables
password="Sciencewins303!"
user=$(whoami)

# Change password
/usr/bin/dscl . passwd /Users/$user "$password"

status=$?

# Alert the end user of status
if [ $status == 0 ]; then

echo "Password was changed successfully."
runCommand="button returned of (display dialog \"Password was changed successfully.\" with title \"Computer Information\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"Super!\"} default button {\"Super!\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )
echo "Password was changed successfully."

elif [ $status != 0 ]; then

runCommand="button returned of (display dialog \"An error was encountered while attempting to change the password. /usr/bin/dscl exited $status.\" with title \"Computer Information\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"I will let IT know!\"} default button {\"I will let IT know!\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )
echo "An error was encountered while attempting to change the password. /usr/bin/dscl exited $status."

fi

exit $status

