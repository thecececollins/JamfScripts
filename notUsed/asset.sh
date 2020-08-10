#!/bin/bash

## Variables ##
MACADDRESS=$(networksetup -getmacaddress en0 | awk '{ print $3 }')
JSS="https://narrativescience.jamfcloud.com"
API_USER="autopkgr"
API_PASS="FirmFlameWonderCareful1!"
UUID=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')
ASSET_TAG_INFO=$(curl -H "Accept: text/xml" -sfku "$API_USER:$API_PASS" "$JSS/JSSResource/computers/udid/$UUID/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
SERIAL_NUMBER=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
MODEL_NAME=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3" "$4}')
REALNAME=$(finger $(whoami) | egrep -o 'Name: [a-zA-Z0-9 ]{1,}' | cut -d ':' -f 2 | xargs echo)

## Name Changing ##

if [ -n "$ASSET_TAG_INFO" ]; then
	echo "Processing new name for this client..."
	echo "Changing name..."
	scutil --set HostName "$REALNAME $MODEL_NAME"
	scutil --set ComputerName "$REALNAME $MODEL_NAME"
	scutil --set LocalHostName "$REALNAME $MODEL_NAME"
	jamf setComputerName -name "$REALNAME $MODEL_NAME"
	echo "Name change complete: $REALNAME $MODEL_NAME ($ASSET_TAG_INFO - $SERIAL_NUMBER)"

else
	echo "Asset Tag information was unavailable. Using Serial Number instead."
	echo "Changing Name..."
	scutil --set HostName "$REALNAME $MODEL_NAME"
	scutil --set ComputerName "$REALNAME $MODEL_NAME"
	scutil --set LocalHostName "$REALNAME $MODEL_NAME"
	jamf setComputerName -name "$REALNAME $MODEL_NAME"
	echo "Name Change Complete: $REALNAME $MODEL_NAME ($SERIAL_NUMBER)"

fi

## Notification ##

JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Narrative Science"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Sync.icns"
ADESC="Natural"


"$JH" -windowType utility -title "$TITLE" -heading "Success!" -description "Computer Name has been successfully added to the Jamf computer record." -button1 "Awesome" -icon "$ICON" -alignDescription natural -alignHeading natural