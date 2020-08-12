#!/bin/bash


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# This script will accomplish the following:
# 			- Building on top of Base image Script
#
#
#
# Written by: Collins
# Edited by: Collins
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
TITLE="Company Name"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
ADESC="Natural"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Prepare Homebrew
brew update
brew doctor

# Install Postgres
brew install postgresql

# Install Lunchy
gem install lunchy
