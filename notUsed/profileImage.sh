#!/bin/sh

# Get Logged in User
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Delete any Photo currently used.
dscl . delete /Users/$loggedInUser jpegphoto
sleep 1
# Delete File path
dscl . delete /Users/$loggedInUser Picture
sleep 1
# Set New Icon
dscl . create /Users/$loggedInUser Picture "//Library/Desktop\ Pictures/circle\ icon\copy 3.jpg"
