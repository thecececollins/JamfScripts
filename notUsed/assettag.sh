#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# Copyright (c) 2016 Jamf.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the Jamf nor the names of its contributors may be
#                 used to endorse or promote products derived from this software without 
#                 specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# This script was designed to be used in conjunction with Casper Imaging. You can append 
# your asset tag as such (i.e., Rosko's MacBook Pro-US123456). This script will be run at
# reboot after imaging and grep out the US123456 to be uploaded to the devices asset tag
# field in the JSS and then fix the computer name.
#
# REQUIREMENTS:
#			- Jamf Pro
#			- Script set to run "At Reboot"
#			- API User w/ Update Permssion for Computer Objects
#
#
# For more information, visit https://github.com/jamfprofessionalservices
#
#
# Written by: Joshua Roskos | Professional Services Engineer | JAMF Software
#
# Created On: November 2nd, 2016
# Updated On: November 2nd, 2016
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# URL of the Jamf Pro server (ie. https://jamf.acme.com:8443)
jamfProURL=""

# API user account in Jamf Pro w/ Update permission
apiUser=""

# Password for above API user account
apiPass=""

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CHECK IF JAMF PRO IS AVAILABLE
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

echo ""
echo "=====Checking Network Location====="
echo "Checking if Jamf Pro is available..."
/usr/local/jamf/bin/jamf checkJSSConnection -retry 30 > /dev/null 2>&1

if [[ $? != 0 ]]; then
	echo "   > Jamf Pro is unavailable..."
	echo "=====Exiting Check====="
	exit 1
else
	echo "   > Jamf Pro is available!"
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CHECK IF COMPUTER IS IN JAMF PRO
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

echo "Checking if mac is enrolled in Jamf Pro..."
macSerial=$( system_profiler SPHardwareDataType | grep Serial |  awk '{print $NF}' )
jamfProId=$( /usr/bin/curl -s -u ${apiUser}:${apiPass} -H "Accept: application/xml" ${jamfProURL}/JSSResource/computers/serialnumber/${macSerial}/subset/general | perl -lne 'BEGIN{undef $/} while (/<id>(.*?)<\/id>/sg){print $1}' | head -1 )

while [ $? != 0 ]; do
	echo "   > Computer is not in Jamf Pro, waiting 30 seconds and retrying..."
	sleep 30
	jamfProId=$( /usr/bin/curl -s -u ${apiUser}:${apiPass} -H "Accept: application/xml" ${jamfProURL}/JSSResource/computers/serialnumber/${macSerial}/subset/general | perl -lne 'BEGIN{undef $/} while (/<id>(.*?)<\/id>/sg){print $1}' | head -1 )
done
echo "   > Found computer in Jamf Pro!"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# GET & SET COMPUTER NAME
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Name of extension Attribute in Jamf Pro
imagingCompName=$( /usr/sbin/scutil --get ComputerName )
compName=$( echo ${imagingCompName} | sed 's/-.*//' )
assetTag=$( echo ${imagingCompName} | sed 's/.*-//' )

# Setting Computer Name
echo "Setting Computer Name..."
/usr/sbin/scutil --set HostName ${compName}
#/usr/sbin/scutil --set LocalHostName ${compName}
/usr/sbin/scutil --set ComputerName ${compName}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# SEND ASSET TAG TO JAMF PRO SERVER
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

echo "Sending AssetTag (${assetTag}) for Computer (${compName}) to Jamf Pro..."
/usr/bin/curl -sfku ${apiUser}:${apiPass} -X PUT -H "Content-Type: text/xml" -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?> <computer> <general> <asset_tag>${assetTag}</asset_tag> </general> </computer>" ${jamfProURL}/JSSResource/computers/id/${jamfProId} > /dev/null

if [ "$?" != "0" ]; then
	echo "   > Error updating asset tag in Jamf Pro."
	echo "=====Exiting Check====="
	exit 2
else
	echo "   > Successfully updated asset tag in Jamf Pro"
fi

echo "=====Completed Check Successfully====="

exit 0
