#!/bin/sh

# The purpose of this script is to delete all browser caches.
#
#
# Edited by Collins 10/17/2019

ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"


CLEARCACHE=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Google Chrome Cache" -heading "Please exit all Google Chrome pages before proceeding" -alignHeading center -description "You Chrome browser cache will be cleared when you click the button below.  This may take several minutes and you will be notified when the process completes. Thank you for your patience." -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarInfo.icns -button1 "Clear Cache" -button2 "Cancel" -defaultButton "1" -cancelButton "2")

USER=$(who | grep console | awk '{print $1}')

# If the user clicks Erase Cache

if [ "$CLEARCACHE" == "0" ]; then
	echo "Clearing Cache"
		sleep 2
		rm -R "/Users/$USER/Library/Caches/Google"
		/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Internet Browser Web Cache" -heading "Process Complete" -alignHeading center -description "Your web browser caches have been cleared for Google Chrome." -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarSitesFolderIcon.icns -button1 " Exit " -defaultButton "1"
	exit 1

# if the user clicks cancel
elif [ "$CLEARCACHE" == "2" ]; then
	echo "User canceled cache clear";   
	exit 1
fi