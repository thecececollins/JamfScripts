#!/bin/bash -x


#############
# Variables #
#############

# JSS information
jssurl="https://[companyname].jamfcloud.com" # example: https://example.com:8443
username=""
password=""
uuid=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')

# Local Information Variables
realname=$(finger $(whoami) | egrep -o 'Name: [a-zA-Z0-9 ]{1,}' | cut -d ':' -f 2 | xargs echo)
modelname=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3" "$4}')

# Grab serial number so we can edit the right computer record
serialnumber=`ioreg -l | awk '/IOPlatformSerialNumber/ { print $4;}' | sed 's/"//' | sed 's/"//'`

###############################
#          User input         #
###############################

# Get asset tag number
assettag=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Enter the Asset Tag number (xxxx) located in the top left corner above the keyboard:" default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)

echo $assettag


# Get user location
getlocation() {
thelocation=$(osascript <<AppleScript
set mylocation to {"Chicago HQ", "Seattle", "New York"}
set selectedlocation to {choose from list mylocation}
AppleScript
echo "${thelocation}"
)
}

getlocation
echo "${thelocation}"



# Get user department
getdepartment() {
thedepartment=$(osascript <<AppleScript
set mydepartment to {"Building", "CloudOps", "Customer Success", "Design", "Engineering", "Executive Leadership ", "Finance", "IT", "Marketing", "Product", "Sales", "Talent & Workplace"}
set selecteddepartment to {choose from list mydepartment}
AppleScript
echo "${thedepartment}"
)
}

getdepartment
echo "${thedepartment}"


# Make temp files
touch /tmp/setemail.xml
touch /tmp/setemail2.xml

# Set email address by prompting the user for input with applescript
email=`/usr/bin/osascript <<EOT
tell application "System Events"
activate
set email to text returned of (display dialog "Input your [companyname] email address:" default answer "OK" with icon 2)
end tell
EOT`

# Get current user and location information from the JSS
curl -k -u $username:$password $jssurl/JSSResource/computers/serialnumber/$serialnumber/subset/location -X GET | tidy -xml -utf8 -i > /tmp/setemail.xml

# Set the email address
cat /tmp/setemail.xml | sed 's/<email_address>.*<\/email_address>/<email_address \/>/' | sed "s/<email_address \/>/<email_address>$email<\/email_address>/g" > /tmp/setemail2.xml

# Submit new user and location information to the JSS
curl -k -u $username:$password $jssurl/JSSResource/computers/serialnumber/$serialnumber/subset/location -T "/tmp/setemail2.xml" -X PUT

rm /tmp/setemail.xml
rm /tmp/setemail2.xml

# Create revised computer name variable
newcomputername="$realname $modelname - $assettag"

# Update Jamf Pro API with new information
sudo jamf recon -assetTag $assettag -department $thedepartment -building $thelocation
scutil --set HostName "$newcomputername"
scutil --set ComputerName "$newcomputername"
scutil --set LocalHostName "$newcomputername"
jamf setComputerName -name "$newcomputername"
dscacheutil -flushcache

# Updated JSS variables
jssassettag=$(curl -H "Accept: text/xml" -sfku "$apiuser:$apipassword" "$jssurl/JSSResource/computers/udid/$uuid/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
jssdepartment=$(curl -H "Accept: text/xml" -sku "$apiuser:$apipassword" "$jssurl/JSSResource/computers/serialnumber/$serialnumber" \ -X GET | xmllint --xpath '/computer/location/department/text()' -)
jsslocation=$(curl -H "Accept: text/xml" -sku "$apiuser:$apipassword" "$jssurl/JSSResource/computers/serialnumber/$serialnumber" \ -X GET | xmllint --xpath '/computer/location/building/text()' -)



# Information to display to end-user in "sync completion" alert (section below)
displayinfo="The below information has been successfully synced with Jamf Pro.

----------------------------------------------
GENERAL

Location: $jsslocation
Department: $jssdepartment
Email: $email
----------------------------------------------
HARDWARE

Asset Tag Number: $jssassettag
Computer Name: $newcomputername
----------------------------------------------


You are all set. Welcome to Jamf Pro! :)"



# Sync completion alert to end-user (referencing section above for what to display)
runCommand="button returned of (display dialog \"$displayinfo\" with title \"Computer Information\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"Super!\"} default button {\"Super!\"})"

clickedButton=$( /usr/bin/osascript -e "$runcommand" )

exit
