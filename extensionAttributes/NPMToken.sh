#!/bin/sh
##############################################################################
# A script to retrieve the NPM Token being used by a machine.                #
# If no NPM Token is found, "Not Configured" will return back.      #
##############################################################################

RESULT="Not Configured"

BASH=~/.bash_profile
ZSH=~/.zshrc
XON=~/.xonshr

# Check to see if bash profile exists and has "NPM_AUTH_TOKEN="
if [ -f "$BASH" ] && grep -q NPM_AUTH_TOKEN= ~/.bash_profile; then
	RESULT=$(sed -n -e 's/^.*NPM_AUTH_TOKEN=//p' ~/.bash_profile | sed 's/"//g')

# If not, check to see if zshell profile exists and has "NPM_AUTH_TOKEN="
elif [ -f "$ZSH" ] && grep -q NPM_AUTH_TOKEN= ~/.zshrc; then
	RESULT=$(sed -n -e 's/^.*NPM_AUTH_TOKEN=//p' ~/.zshrc | sed 's/"//g')

# If not, check to see if xonshr profile exists and has "NPM_AUTH_TOKEN="
elif [ -f "$XON" ] && grep -q NPM_AUTH_TOKEN= ~/.xonshr; then
		RESULT=$(sed -n -e 's/^.*NPM_AUTH_TOKEN=//p' ~/.xonshr | sed 's/"//g')

# If not, assume there isn't an NPM Token being used by machine 
fi

echo "<result>$RESULT</result>"
exit 0



# This is a test NPM Token to use for bash/zshell profiles (remove the # in front of "export" when adding to profiles)
#export NPM_AUTH_TOKEN=zshbadee-fdcc-4559-aaa3-35d128d8699c
