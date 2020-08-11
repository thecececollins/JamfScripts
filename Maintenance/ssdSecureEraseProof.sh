#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This script will accomplish the following:
# 			- Collect the name of the Mac
#			- Collect the serial number of the Mac
#			- Collect the serial number of the SSD
#			- Bypass all encryption and credentials needed or use Admin credentials
#			- Securely erase the hard drive (disk2) with 7-pass
#			- Collect date and time of completion
#			- Display all information when complete (with "Secure Erase Status: COMPLETE or FAILED")
#			- Submit output to AWS S3
#
# In order for this script to work effectively you will need to run the script from one computer
# with the target computer booted to Target Disk Mode and hardwired to the computer running the script.
#
# Written by: CCollins | IT Manager | 
# Edited by: CCollins | IT Manager |  
#
# Created On: September 26th, 2019
# Updated On: 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Collect the name of the Mac
runCommand=$( /usr/sbin/scutil --get ComputerName )
computerName="$runCommand"

# Collect the serial number of the Mac
runCommand=$( /usr/sbin/system_profiler SPHardwareDataType | /usr/bin/grep "Serial Number" | /usr/bin/awk -F ": " '{ print $2 }' )
serialNumber="$runCommand"

# Collect the serial number of the SSD


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# PROCESSES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Bypass all encryption and credentials needed or use Admin credentials

# Securely erase the hard drive (disk2) with 7-pass

# Collect date and time of completion
runCommand=$( /bin/date )
timeInfo="$runCommand"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# OUTPUT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Display all information when complete (with "Secure Erase Status: COMPLETE or FAILED")
displayInfo="COMPUTER HAS BEEN SECURELY ERASED

----------------------------------------------
Computer Name: $computerName

Computer Serial Number: $serialNumber

Date and Time of Completion: $timeInfo
----------------------------------------------

This task has been completed and recorded for security purposes. These results will be stored in the Narrative Science AWS S3 Bucket."

# Display output
runCommand="button returned of (display dialog \"$displayInfo\" with title \"Security Report\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"Super!\"} default button {\"Super!\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )


# Submit output to AWS S3
