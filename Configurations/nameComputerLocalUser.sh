
#!/bin/bash

# Get the logged-in user using stat (most reliable in Jamf)
loggedInUser=$(stat -f "%Su" /dev/console 2>/dev/null)

if [[ -z "$loggedInUser" ]]; then
  echo "Error: Could not determine logged-in user."
  exit 1
fi

# Get the full name of the user from the directory services
fullname=$(dscl . read /Users/$loggedInUser RealName 2>/dev/null | awk '{print $2, $3, $4, $5, $6, $7, $8, $9}')

if [[ -z "$fullname" ]]; then
    echo "Error: Could not retrieve user's full name."
    exit 1
fi

# Extract the last name
lastname=$(echo "$fullname" | awk '{print $NF}')

# Capitalize the first letter of the last name
capitalizedLastname=$(echo "$lastname" | awk '{print toupper(substr($1,1,1)) substr($1,2)}')

# Remove "new line"
capitalizedLastname=$(echo $capitalizedLastname | tr -d '\n')

# Collect device information
modelName=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3" "$4}')
UUID=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')
serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')

newComputerName="$capitalizedLastname $modelName - $serialNumber"

# Remove "new line" again to be safe and and ensure it meets DNS requirements
newComputerName=$(echo $newComputerName | tr -d '\n')

## Name Changing ##

	echo "Updating computer name..."
	scutil --set HostName "$newComputerName"
	scutil --set ComputerName "$newComputerName"
	jamf setComputerName -name "$newComputerName"
    	dscacheutil -flushcache
	echo "Computer name update complete: $newComputerName"


## Notification ##

#JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
#TITLE="Name Computer"
#ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Sync.icns"
#ADESC="Natural"


#"$JH" -windowType utility -title "$TITLE" -heading "Success!" -description "Computer name has been successfully added to the Jamf computer record as $newComputerName" -button1 "Awesome" -icon "$ICON" -alignDescription natural -alignHeading natural
