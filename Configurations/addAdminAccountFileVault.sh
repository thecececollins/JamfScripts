#!/bin/bash

## Self Service policy to add the logged in user to the enabled list
## of FileVault 2 users.

## Pass the credentials for an admin account that is authorized with FileVault 2
adminName=$4
adminPass=$5
userName=$USERNAME

if [[ "$adminName" == "" ]];
then 
	echo "Username undefined. Please pass the management account username in parameter 4" 
	exit 1
fi

if [[ "$adminPass" == "" ]];
then
	echo "Password undefined. Please pass the management account password in parameter 5"
	exit 2
fi

## Get the logged in user's name
userName=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

## This first user check sees if the Admin account is already authorized with FileVault 2
userCheck=$(fdesetup list | awk -v usrN="$userName" -F, 'index($0, usrN) {print $1}')
if [[ "$userCheck" == "$adminName" ]];
then 
	echo "This user is already added to the FileVault 2 list." 
	exit 3
fi

## Check to see if the encryption process is complete (this section stopped working in 10.15.3)
#encryptCheck=$(fdesetup status)
#statusCheck=$(echo "$encryptCheck" | grep "FileVault is On.")
#expectedStatus="FileVault is On. FileVault master keychain appears to be installed."
#if [[ "$statusCheck" != "$expectedStatus" ]];
#then
	#echo "The encryption process has not completed, unable to add user at this time."
	#echo "$encryptCheck"
	#exit 4
#fi

## Get the logged in user's password via a prompt
echo "Prompting $userName for their login password."
userPass="$(osascript -e 'Tell application "System Events" to display dialog "To complete your computer enrollment, please input your computer password (carefully):" default answer "" with title "Login Password" with text buttons {"Ok"} default button 1 with hidden answer' -e 'text returned of result')"

echo "Adding user to FileVault 2 list."

# create the plist file:
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Username</key>
<string>'$userName'</string>
<key>Password</key>
<string>'$userPass'</string>
<key>AdditionalUsers</key>
<array>
    <dict>
        <key>Username</key>
        <string>'$adminName'</string>
        <key>Password</key>
        <string>'$adminPass'</string>
    </dict>
</array>
</dict>
</plist>' > /tmp/fvenable.plist

# now enable FileVault
fdesetup add -i < /tmp/fvenable.plist

## This second user check sees if the Admin account was successfully added to the FileVault 2 list
userCheck=$(fdesetup list | awk -v usrN="$adminName" -F, 'index($0, usrN) {print $1}')
if [[ "$userCheck" != "$adminName" ]];
then
	echo "Failed to add user to FileVault 2 list."
	exit 5
fi

echo "$adminName has been added to the FileVault 2 list."

# hide admin account from login screen
sudo dscl . create /Users/admin IsHidden 1

/usr/local/bin/jamf recon
