#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# This script will accomplish the following:
# 			- Builds on top of the Base Setup
# 			- Installs Pants
# 			- Installs PM2
# 			- Adds to the NS profile:
# 				- Pants Env Vars
# 				- LEXIO_ROOT Env Var
#
#
# Exit Code Descriptions:
# 			exit 1 - User Running Policy Doesn't Match User Assigned in JSS
# 			exit 2 - No JSS User Assigned in JSS
# 			exit 3 - JSS is not Accessible
#			exit 5 - Unknown Error
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
# Collecting user variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Test SSH
