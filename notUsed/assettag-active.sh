#!/bin/bash

asset=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Enter Asset Number: " default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)

jamf recon -assetTag $asset

JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="GROUP NAME"
ICON="ICON Location"
ADESC="Natural"


"$JH" -windowType utility -title "$TITLE" -heading "Success!" -description "Asset Tag has been successfully added to the Jamf computer record." -button1 "Proceed" -icon "$ICON" -alignDescription natural -alignHeading natural

exit