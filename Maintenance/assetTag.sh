#!/bin/bash

# Local Information Variables
realName=$(finger $(whoami) | egrep -o 'Name: [a-zA-Z0-9 ]{1,}' | cut -d ':' -f 2 | xargs echo)
modelName=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3" "$4}')
serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')

# JSS API Information Variables
apiUser="Autopkgr"
apiPassword="FirmFlameWonderCareful1!"
jss="https://narrativescience.jamfcloud.com"
uuid=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')
jssAssetTag=$(curl -H "Accept: text/xml" -sfku "$apiUser:$apiPassword" "$jss/JSSResource/computers/udid/$uuid/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
jssDepartment=$(curl -H "accept: text/xml" -sku "$apiUser:$apiPassword" "$jss/JSSResource/computers/serialnumber/$serialNumber" \ -X GET | xmllint --xpath '/computer/location/department/text()' -)
jssLocation=$(curl -H "accept: text/xml" -sku "$apiUser:$apiPassword" "$jss/JSSResource/computers/serialnumber/$serialNumber" \ -X GET | xmllint --xpath '/computer/location/building/text()' -)


# Get Asset Tag Number
assetTag=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Enter the Asset Tag number (NSxxxx) located in the top left corner above the keyboard:" default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)

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


# Update Jamf Pro API with new information
#sudo jamf recon -building $theLocation
#sudo jamf recon -department $theDepartment
#sudo jamf recon -assetTag $assetTag
#scutil --set HostName "$realName $modelName - $assetTag"
#scutil --set ComputerName "$realName $modelName - $assetTag"
#scutil --set LocalHostName "$realName $modelName - $assetTag"
#jamf setComputerName -name "$realName $modelName - $assetTag"
#dscacheutil -flushcache


# Display computer name
runCommand=$( /usr/sbin/scutil --get ComputerName )
computerName="$runCommand"

## Format information #####
displayInfo="The below information has been successfully synced with Jamf Pro.
----------------------------------------------
GENERAL

Location: $jssLocation
Department: $jssDepartment
----------------------------------------------
HARDWARE

Asset Tag Number: $jssAssetTag
Computer Name: $computerName
----------------------------------------------


You are all set. Welcome to Jamf Pro! :)"



## Display information to end user #####


runCommand="button returned of (display dialog \"$displayInfo\" with title \"Computer Information\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"Super!\"} default button {\"Super!\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )

exit
