#!/bin/bash

REALNAME=$(finger $(whoami) | egrep -o 'Name: [a-zA-Z0-9 ]{1,}' | cut -d ':' -f 2 | xargs echo)
MODEL_NAME=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3" "$4}')
JSS="https://narrativescience.jamfcloud.com"
API_USER="autopkgr"
API_PASS="apipassword"
UUID=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')
ASSET_TAG_INFO=$(curl -H "Accept: text/xml" -sfku "$API_USER:$API_PASS" "$JSS/JSSResource/computers/udid/$UUID/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')


## Name Changing ##

if [ -n "$ASSET_TAG_INFO" ]; then
	echo "Processing new name for this device..."
	echo "Changing name..."
	scutil --set HostName "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	scutil --set ComputerName "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	scutil --set LocalHostName "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	jamf setComputerName -name "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	dscacheutil -flushcache
	echo "Name change complete: $REALNAME $MODEL_NAME - $ASSET_TAG_INFO"

else
	echo "Asset Tag information was unavailable. Using Serial Number instead."
	echo "Changing name..."
	scutil --set HostName "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	scutil --set ComputerName "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	scutil --set LocalHostName "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	jamf setComputerName -name "$REALNAME $MODEL_NAME - $ASSET_TAG_INFO"
	dscacheutil -flushcache
	echo "Name Change Complete: $REALNAME $MODEL_NAME - $ASSET_TAG_INFO"

fi

## Notification ##

JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Narrative Science"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Sync.icns"
ADESC="Natural"


"$JH" -windowType utility -title "$TITLE" -heading "Success!" -description "Computer Name ($REALNAME $MODEL_NAME - $ASSET_TAG_INFO) and Asset Tag ($ASSET_TAG_INFO) has been successfully added to the Jamf computer record." -button1 "Awesome" -icon "$ICON" -alignDescription natural -alignHeading natural
