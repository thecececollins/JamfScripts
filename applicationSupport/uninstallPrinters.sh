#!/bin/sh

#########################################################################################
# A script to remove all printer/scanner drivers and configurations.                    #
#########################################################################################

JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Narrative Science"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
ADESC="Natural"

"$JH" -windowType utility -title "$TITLE" -heading "Uninstall Printers" -description "
This will do the following:
----------------------------------------------
- Uninstall all Chicago NS printers from System Preferences
- Uninstall all related printer drivers
- Restart Mac to finalize the uninstallation process

** This should NOT affect any additional printers that have been installed.
----------------------------------------------" -button1 "Let's do this!" -icon "$ICON" -alignDescription natural -alignHeading natural


# Removes printers from System Preferences
lpstat -p | awk '{print $2}' | while read printer
do
echo "Deleting Printer:" Amtrak_Printer
lpadmin -x Amtrak_Printer
echo "Deleting Printer:" CTA_Printer
lpadmin -x CTA_Printer
echo "Deleting Printer:" Metra_Printer
lpadmin -x Metra_Printer
echo "Deleting Printer:" Brother_MFC_L8600CDW
lpadmin -x Brother_MFC_L8600CDW
echo "Deleting Printer:" Brother_MFC_L8600CDW__30055cb56330_
lpadmin -x Brother_MFC_L8600CDW__30055cb56330_
echo "Deleting Printer:" Brother_MFC_L8600CDW__30055cb56330____Fax
lpadmin -x Brother_MFC_L8600CDW__30055cb56330____Fax
echo "Deleting Printer:" Brother_MFC_L8600CDW___Fax
lpadmin -x Brother_MFC_L8600CDW___Fax
echo "Deleting Printer:" Brother_MFC_L8850CDW
lpadmin -x Brother_MFC_L8850CDW
done

# Removes printer drivers
sudo rm -r /Library/Printers/Brother
sudo rm -r /Library/Image\ Capture/Devices/Brother\ Scanner.app
sudo rm -r /Library/Image\ Capture/TWAIN\ Data\ Sources
sudo rm -r /Library/Printers/PPDs

exit 0