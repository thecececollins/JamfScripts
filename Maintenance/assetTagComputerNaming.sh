#!/bin/bash

# Local Information Variables
realName=$(finger $(whoami) | egrep -o 'Name: [a-zA-Z0-9 ]{1,}' | cut -d ':' -f 2 | xargs echo)
modelName=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3" "$4}')
serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')

# JSS API Information Variables
apiUser=""
apiPassword=""
jss="https://[companyname].jamfcloud.com"
uuid=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')


# Get Asset Tag Number
assetTag=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Enter the Asset Tag number (xxxx) located in the top left corner above the keyboard:" default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)

echo $assetTag


# Get user Location
getLocation() {
theLocation=$(osascript <<AppleScript
set myLocation to {"Chicago HQ", "Seattle", "New York"}
set selectedLocation to {choose from list myLocation}
AppleScript
echo "${theLocation}"
)
}

getLocation
echo "${theLocation}"



# Get user Department
getDepartment() {
theDepartment=$(osascript <<AppleScript
set myDepartment to {"Building", "CloudOps", "Customer Success", "Design", "Engineering", "Executive Leadership ", "Finance", "IT", "Marketing", "Product", "Sales", "Talent & Workplace"}
set selectedDepartment to {choose from list myDepartment}
AppleScript
echo "${theDepartment}"
)
}

getDepartment
echo "${theDepartment}"


#plist="$1/Library/Receipts/JSSData.plist"
#/usr/bin/defaults write "$plist" building "$theLocation"

# Create revised computer name variable
newComputerName="$realName $modelName - $assetTag"

# Update Jamf Pro API with new information
sudo jamf recon -assetTag $assetTag -department $theDepartment -building $theLocation
scutil --set HostName "$newComputerName"
scutil --set ComputerName "$newComputerName"
scutil --set LocalHostName "$newComputerName"
jamf setComputerName -name "$newComputerName"
dscacheutil -flushcache

# Updated JSS variables
jssAssetTag=$(curl -H "Accept: text/xml" -sfku "$apiUser:$apiPassword" "$jss/JSSResource/computers/udid/$uuid/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
jssDepartment=$(curl -H "Accept: text/xml" -sku "$apiUser:$apiPassword" "$jss/JSSResource/computers/serialnumber/$serialNumber" \ -X GET | xmllint --xpath '/computer/location/department/text()' -)
jssLocation=$(curl -H "Accept: text/xml" -sku "$apiUser:$apiPassword" "$jss/JSSResource/computers/serialnumber/$serialNumber" \ -X GET | xmllint --xpath '/computer/location/building/text()' -)



# Information to display to end-user in "sync completion" alert (section below)
displayInfo="The below information has been successfully synced with Jamf Pro.

----------------------------------------------
GENERAL

Location: $jssLocation
Department: $jssDepartment
----------------------------------------------
HARDWARE

Asset Tag Number: $jssAssetTag
Computer Name: $newComputerName
----------------------------------------------


You are all set. Welcome to Jamf Pro! :)"



# Sync completion alert to end-user (referencing section above for what to display)
runCommand="button returned of (display dialog \"$displayInfo\" with title \"Computer Information\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"Super!\"} default button {\"Super!\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )

exit
