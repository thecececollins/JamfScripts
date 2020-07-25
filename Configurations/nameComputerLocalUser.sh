#!/bin/bash

***Variables***
MACADDRESS=$(networksetup -getmacaddress en0 | awk '{ print $3 }')
JSS=https://yourdomainhere.jamfcloud.com
API_USER=yourapirusername
API_PASS=yourapriuserpassword
SERIAL_NUMBER=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
MODEL_NAME=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3" "$4}')
REALNAME=$(finger $(whoami) | egrep -o 'Name: [a-zA-Z0-9 ]{1,}' | cut -d ':' -f 2 | xargs echo)

## Get the Mac's UUID string (required for ASSET_TAG_INFO)
UUID=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')

## Pull the Asset Tag by accessing the computer records "general" subsection
ASSET_TAG_INFO=$(curl -H "Accept: text/xml" -sfku "$API_USER:$API_PASS" "$JSS/JSSResource/computers/udid/$UUID/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')


if [ -n "$ASSET_TAG_INFO" ]; then
	echo "Processing new name for this client..."
	echo "Changing name..."
	scutil --set HostName $REALNAME $MODEL_NAME
	scutil --set ComputerName $REALNAME $MODEL_NAME $ASSET_TAG_INFO - $SERIAL_NUMBER
	echo "Name change complete: $REALNAME $MODEL_NAME ($ASSET_TAG_INFO - $SERIAL_NUMBER)"

else
	echo "Asset Tag information was unavailable. Using Serial Number instead."
	echo "Changing Name..."
	scutil --set HostName $REALNAME $MODEL_NAME
	scutil --set ComputerName $REALNAME $MODEL_NAME $SERIAL_NUMBER
	echo "Name Change Complete: $REALNAME $MODEL_NAME ($SERIAL_NUMBER)"

fi
