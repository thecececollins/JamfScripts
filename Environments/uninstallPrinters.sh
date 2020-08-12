#!/bin/sh

#########################################################################################
# A script to remove all printer/scanner drivers and configurations.                    #
#########################################################################################

JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Company Name"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
ADESC="Natural"

"$JH" -windowType utility -title "$TITLE" -heading "Uninstall Printers" -description "
This will do the following:
----------------------------------------------
- Uninstall all printers from System Preferences
- Uninstall all related printer drivers
- Restart Mac to finalize the uninstallation process

** This should NOT affect any additional printers that have been installed.
----------------------------------------------" -button1 "Let's do this!" -icon "$ICON" -alignDescription natural -alignHeading natural


# Removes printers from System Preferences
lpstat -p | awk '{print $2}' | while read printer
do
echo "Deleting Printer:" [printername]
lpadmin -x [printername]
echo "Deleting Printer:" [printername]
lpadmin -x [printername]
echo "Deleting Printer:" [printername]
lpadmin -x [printername]
echo "Deleting Printer:" [printermodel]
lpadmin -x  [printermodel]
echo "Deleting Printer:" [printermodel]
lpadmin -x [printermodel]
echo "Deleting Printer:" [printermodel]
lpadmin -x [printermodel]
echo "Deleting Printer:" [printermodel]
lpadmin -x [printermodel]
echo "Deleting Printer:" [printermodel]
lpadmin -x [printermodel]
done

# Removes printer drivers
sudo rm -r /Library/Printers/Brother
sudo rm -r /Library/Image\ Capture/Devices/Brother\ Scanner.app
sudo rm -r /Library/Image\ Capture/TWAIN\ Data\ Sources
sudo rm -r /Library/Printers/PPDs

exit 0
