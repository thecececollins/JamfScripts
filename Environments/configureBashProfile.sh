#!/bin/bash

# Notification template
JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Company Name"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
ADESC="Natural"

"$JH" -windowType utility -title "$TITLE" -heading "Base Development Environment Setup" -description "In the next steps, we are going to gather some information in order to configure your new engineering environment.

To continue, you will need the following:
----------------------------------------------
- AWS Access Key ID
- AWS SecretAccess Key
- NPM Auth Token
----------------------------------------------" -button1 "More info..." -icon "$ICON" -alignDescription natural -alignHeading natural


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Collecting user variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# End user Public SSH Key
PUB_KEY=$(<~/.ssh/id_rsa.pub)

# End user prompt to collect the AWS Access Key ID
AWS_ACCESS_KEY_ID=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Please enter your AWS Access Key ID:" default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)
# read $AWS_ACCESS_KEY_ID

# End user prompt to collect the AWS Secret Access Key
AWS_SECRET_ACCESS_KEY=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Please enter your AWS Secret Access Key:" default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)
# read $AWS_SECRET_ACCESS_KEY

# End user prompt to collect the NPM Auth Token
NPM_AUTH_TOKEN=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Please enter your NPM Auth Token:" default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)
# read $NPM_AUTH_TOKEN

# End user prompt to collect the LDAP usernaem
LDAP_USERNAME=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Please enter your LDAP username (first initial + lastname =jappleseed):" default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)
# read $LDAP_USERNAME

# Create NS Bash Profile
touch ~/.[companyname]s-eng-profile


# Add variables
echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ~/.[companyname]-eng-profile
echo "source AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ~/.[companyname]-eng-profile
echo "export NPM_AUTH_TOKEN=$NPM_AUTH_TOKEN" >> ~/.[companyname]-eng-profile
echo "SSH Key=$PUB_KEY" >> ~/.[companyname]-eng-profile
echo "LDAP_USERNAME=$LDAP_USERNAME" >> ~/.[companyname]-eng-profile
