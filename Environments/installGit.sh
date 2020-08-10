#!/bin/bash

# Install/Update Git
## Test if git is installed
if test ! $(which git)
then
	echo "Installing git..."
	brew install git
else
## git is installed but not up-to-date
	echo "Upgrading git..."
	brew update
    brew cleanup
	brew upgrade git
    brew cleanup git
fi

## show version	
gitversion=$(git --version)