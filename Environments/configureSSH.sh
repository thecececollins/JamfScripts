#!/bin/bash

# Exit script on Error
set -e

# Check for SSH Directory
if [ ! -d ~/.ssh ]; then
   mkdir -p ~/.ssh/
fi


# Check for existence of passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
	echo "Execute ssh-keygen --[done]"
fi

# Check for existence of authorized_keys and append the shared ssh keys
if [ ! -f ~/.ssh/authorized_keys ]; then
	touch ~/.ssh/authorized_keys
	echo "Create ~/.ssh/authorized_keys --[done]"
	chmod 700 ~/.ssh/authorized_keys
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	echo "Append the public keys id_rsa into authorized keys --[done]"
	chmod 400 ~/.ssh/authorized_keys
	chmod 700 ~/.ssh/
fi

# Create user's ssh config if not existant
if [ ! -f ~/.ssh/config ]; then
	touch ~/.ssh/config
	echo "StrictHostKeyChecking no" > ~/.ssh/config
	echo "StrictHostKeyChecking no --[done]"
	chmod 644 ~/.ssh/config
fi


PUB_KEY=$(<~/.ssh/id_rsa.pub)
echo "$PUB_KEY" | pbcopy


# Notification template
JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Narrative Science"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
ADESC="Natural"

"$JH" -windowType utility -title "$TITLE" -heading "Base Development Environment Setup" -description "Simply paste (command + v) into the SSH Key field in the Freshservice ticket opened in the next step." -button1 "Open ticket" -icon "$ICON" -alignDescription natural -alignHeading natural

echo "$PUB_KEY" | pbcopy

# Opens Freshservice SSH Key Upload ticket
open https://narrativescience.freshservice.com/support/catalog/items/87 

# Unset error on exit or it will affect after bash command
set +e
