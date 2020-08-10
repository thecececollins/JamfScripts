#!/bin/bash


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# This script will accomplish the following:
# 			- Building on top of Base image Script
# 			- Adds to the NS profile:
# 				- QUILL_ROOT Env Var
#
#
#
# Written by: Collins | IT Lead | Narrative Science
# Edited by: Collins | IT Lead | Narrative Science
#
# Created On: October 17th, 2016
# Updated On: October 17th, 2016
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Notification template
JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Narrative Science"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
ADESC="Natural"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Add variables to NS profile
sudo /Library/PostgreSQL/9.1/uninstall-postgresql.app/Contents/MacOS/installbuilder.sh

# Remove the ini file:
sudo rm /etc/postgres-reg.ini

# Remove the PostgreSQL folder from the system Library:
sudo rm -rf /Library/PostgreSQL

# Restore shared memory settings
sudo rm /etc/sysctl.conf