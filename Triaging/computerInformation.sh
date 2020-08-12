#!/bin/sh

<<ABOUT_THIS_SCRIPT
-----------------------------------------------------------------------
	Written by:William Smith
	Professional Services Engineer
	Jamf
	bill@talkingmoose.net
	https://github.com/talkingmoose/Jamf-Scripts
	
	Originally posted: August 13, 2018
	Updated: April 7, 2019
	Purpose: Display a dialog to end users with computer information when
	run from within Jamf Pro Self Service. Useful for Help Desks to
	ask end users to run when troubleshooting.
	Except where otherwise noted, this work is licensed under
	http://creativecommons.org/licenses/by/4.0/
	"they're good dogs Brent"
INSTRUCTIONS
	1) Edit the "Run Additional Commands" section to choose a behavior
	   for the Enable Remote Support button. This button can do anything
	   you'd like. Three examples are provided:
	   
	   - open an application
	   - run a Jamf Pro policy
	   - email the computer information to your Help Desk
	   
	2) In Jamf Pro choose Settings (cog wheel) > Computer Mangement >
	   Scripts and create a new script. Copy this script in full to the
	   script body and save.
	3) Then choose Computers > Policies and create a new policy. Add
	   the script to the policy and enable it for Self Service.
	4) When an end user calls your Help Desk, the technician can instruct
	   them to open Self Service and run the script for trouble-
	   shooting.
	
-----------------------------------------------------------------------
ABOUT_THIS_SCRIPT



## General section #####


# Display computer name
runCommand=$( /usr/sbin/scutil --get ComputerName )
computerName="Computer Name: $runCommand"

##Get MacModel
#runCommand=$( curl -s -k -u [username]:[password] https://[companyname].jamfcloud.com/JSSResource/computers/macaddress/$MACaddy | xpath /computer/hardware/model | awk -F '[>|<]' '{print ($3)}' )
#macModel="Model: $runCommand"

# Display serial number
runCommand=$( /usr/sbin/system_profiler SPHardwareDataType | /usr/bin/grep "Serial Number" | /usr/bin/awk -F ": " '{ print $2 }' )
serialNumber="Computer Serial Number: $runCommand"

## Find asset tag number
##Get MacAddress
MACaddy=$( networksetup -getmacaddress en0 | awk '{print $3}' | sed 's/:/./g' )
echo "${MACaddy}"

##Get Asset Tag
runCommand=$( curl -s -k -u [username]:[password] https://[companyname].jamfcloud.com/JSSResource/computers/macaddress/$MACaddy | xpath /computer/general/asset_tag | awk -F '[>|<]' '{print toupper($3)}' )
assetTag="Computer Asset Tag: $runCommand"

# Monitor serial number
runCommand=$(system_profiler SPDisplaysDataType | awk '/Display Serial Number/{print $NF;exit}')
MonitorSerialNumber="Monitor Serial Number: $runCommand"

# Display uptime
runCommand=$( /usr/bin/uptime | /usr/bin/awk -F "(up |, [0-9] users)" '{ print $2 }' )
if [[ "$runCommand" = *day* ]] || [[ "$runCommand" = *sec* ]] || [[ "$runCommand" = *min* ]] ; then
	upTime="Uptime: $runCommand"
else
	upTime="Uptime: $runCommand hrs/min"
fi



## Network section #####


# Display active network services and IP Addresses

networkServices=$( /usr/sbin/networksetup -listallnetworkservices | /usr/bin/grep -v asterisk )

while IFS= read aService
do
	activePort=$( /usr/sbin/networksetup -getinfo "$aService" | /usr/bin/grep "IP address" | /usr/bin/grep -v "IPv6" )
	if [ "$activePort" != "" ] && [ "$activeServices" != "" ]; then
		activeServices="$activeServices\n$aService $activePort"
	elif [ "$activePort" != "" ] && [ "$activeServices" = "" ]; then
		activeServices="$aService $activePort"
	fi
done <<< "$networkServices"

activeServices=$( echo "$activeServices" | /usr/bin/sed '/^$/d')


# Display Wi-Fi SSID
model=$( /usr/sbin/system_profiler SPHardwareDataType | /usr/bin/grep 'Model Name' )

if [[ "$model" = *Book* ]]; then
	runCommand=$( /usr/sbin/networksetup -getairportnetwork en0 | /usr/bin/awk -F ": " '{ print $2 }' )
else
	runCommand=$( /usr/sbin/networksetup -getairportnetwork en1 | /usr/bin/awk -F ": " '{ print $2 }' )
fi

SSID="SSID: $runCommand"


# Cisco AnyConnect VPN IP address
testFile="/opt/cisco/anyconnect/bin/vpn" # Cisco VPN binary

if [[ -f "${testFile}" ]] ; then
	# Cisco AnyConnect installed; read current IP Address
	vpnIP=$(/opt/cisco/anyconnect/bin/vpn stats | grep "Client Address (IPv4):" | awk '{print $4}')

	if [[ "${vpnIP}" != "" ]]; then
		# IP address is *not* blank, report the IP address
		vpnIPaddress="VPN IP Address: ${vpnIP}"
	else
		# IP address is blank, report no connection
		vpnIPaddress="No VPN Connection"
	fi

else

	# Cisco AnyConnect is not installed
	vpnIPaddress="Cisco AnyConnect not found"

fi


# Display SSH status
runCommand=$( /usr/sbin/systemsetup -getremotelogin | /usr/bin/awk -F ": " '{ print $2 }' ) 
SSH="SSH: $runCommand"


# Display date, time and time zone
runCommand=$( /bin/date )
timeInfo="Date and Time: $runCommand"


# Display network time server
# runCommand=$( /usr/sbin/systemsetup -getnetworktimeserver )
# timeServer="$runCommand"



## Active Directory section #####


# Display Active Directory binding
#runCommand=$( /usr/sbin/dsconfigad -show | /usr/bin/grep "Directory Domain" | /usr/bin/awk -F "= " '{ print $2 }' )

#if [ "$runCommand" = talkingmoose.pvt ]; then
#	AD="Bound to Active Directory: Yes"
#else
#	AD="Bound to Active Directory: No"	
#fi


# Test Active Directory binding
# runCommand=$( /usr/bin/dscl "/Active Directory/TALKINGMOOSE/All Domains" read /Users )

# if [ "$runCommand" = "name: dsRecTypeStandard:Users" ]; then
#	testAD="Test Active Directory Connection: Success"
# else
#	testAD="Test Active Directory Connection: Fail"	
# fi



## Hardware/Software section #####


# Display free space
FreeSpace=$( /usr/sbin/diskutil info "Macintosh HD" | /usr/bin/grep  -E 'Free Space|Available Space' | /usr/bin/awk -F ":\s*" '{ print $2 }' | awk -F "(" '{ print $1 }' | xargs )
FreePercentage=$( /usr/sbin/diskutil info "Macintosh HD" | /usr/bin/grep -E 'Free Space|Available Space' | /usr/bin/awk -F "(\\\(|\\\))" '{ print $6 }' )
diskSpace="Disk Space: $FreeSpace free ($FreePercentage available)"


# Display operating system
macOSVersion=$( /usr/bin/sw_vers -productVersion)
macOSBuild=`sw_vers -buildVersion`
operatingSystem="Operating System: $macOSVersion ($macOSBuild)"

# Display battery cycle count
runCommand=$( /usr/sbin/ioreg -r -c "AppleSmartBattery" | /usr/bin/grep '"CycleCount" = ' | /usr/bin/awk '{ print $3 }' | /usr/bin/sed s/\"//g )
batteryCycleCount="Battery Cycle Count: $runCommand"

# Display Battery Health Status
runCommand=`ioreg -r -c "AppleSmartBattery" | grep "PermanentFailureStatus" | awk '{print $3}' | sed s/\"//g`
if [ "$runCommand" == "1" ]; then
runCommand="Failing"
elif [ "$runCommand" == "0" ]; then
runCommand="Good"
fi
batteryHealthStatus="Battery Health Status: $runCommand"



## Format information #####


displayInfo="
----------------------------------------------
GENERAL
$computerName
$serialNumber
$assetTag
$MonitorSerialNumber
$upTime
----------------------------------------------
HARDWARE/SOFTWARE
$diskSpace
$operatingSystem
$batteryCycleCount
$batteryHealthStatus
----------------------------------------------
NETWORK
$activeServices
$SSID
$vpnIPaddress
$SSH
$timeInfo
$timeServer
----------------------------------------------


Feel free to take a screenshot of this information and attach it to your IT ticket."



## Display information to end user #####

runCommand="button returned of (display dialog \"$displayInfo\" with title \"Computer Information\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"Super!\"} default button {\"Super!\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )



## Run additional commands #####


#if [ "$clickedButton" = "Submit info to IT" ]; then

	# open a remote support application
	# /usr/bin/open -a "/Applications/TeamViewer.app"

	# run a policy to enable remote support
	# /usr/local/bin/jamf policy -event EnableRemoteSupport
	
	# email computer information to it
	#currentUser=$( stat -f "%Su" /dev/console )
	#sudo -u "$currentUser" /usr/bin/open "mailto:[support email]?subject=Computer Information ($serialNumber)&body=$displayInfo"
	
	#if [ $? = 0 ]; then
		#/usr/bin/osascript -e 'display dialog "Remote support enabled." with title "Computer Information" with icon file posix file "/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns" buttons {"OK"} default button {"OK"}' &
	#else
		#/usr/bin/osascript -e 'display dialog "Failed enabling remote support." with title "Computer Information" with icon file posix file "/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns" buttons {"OK"} default button {"OK"}' &
	#fi
	
#fi


exit 0
