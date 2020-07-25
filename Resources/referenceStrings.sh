#!/bin/bash

#If running scripts from jamf they will run as root, to get the current logged in user for a script you need to add in:
CurrentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
