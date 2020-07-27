#!/bin/bash

#########################################################################################
# A script to list all printer/scanner drivers and configurations.                      #
#########################################################################################


# Lists printers from System Preferences
RESULT=$(lpstat -p | awk '{print $2}')

echo "<result>$RESULT</result>"
