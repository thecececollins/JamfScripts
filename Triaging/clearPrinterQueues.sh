#!/bin/sh

lpstat -p | awk '{print $2}' | while read printer
do
	echo "Clearing Queue for Printer:" Amtrak_Printer
	lprm - -P Amtrak_Printer
	echo "Clearing Queue for Printer:" CTA_Printer
	lprm - -P CTA_Printer
	echo "Clearing Queue for Printer:" Metra_Printer
	lprm - -P Metra_Printer
done