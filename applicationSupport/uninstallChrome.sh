#!/bin/bash

echo "Quitting Google Chrome and preparing to fully remove all components of Chrome"
osascript -e 'quit app "Google Chrome"'

echo "NOTE: Nothing to be afraid of, Google saves all of your bookmarks, history, and extensions in your Google account so they will return when we re-sign you in."
echo "Now we are removing all remaining files of Google Chrome... please enter your password (you will not see it as you type)."
sudo rm -rf /Applications/Google\ Chrome.app/
sudo rm -rf ~/Library/Application\ Support/Google/Chrome/
sudo rm ~/Library/Application\ Support/CrashReporter/Google\ Chrome*
sudo rm ~/Library/Preferences/com.google.Chrome*
sudo rm ~/Library/Preferences/Google\ Chrome*
sudo rm -rf ~/Library/Caches/com.google.Chrome*
sudo rm -rf ~/Library/Saved\ Application\ State/com.google.Chrome.savedState/
sudo rm ~/Library/Google/GoogleSoftwareUpdate/Actives/com.google.Chrome
sudo rm ~/Library/Google/Google\ Chrome*
sudo rm -rf ~/Library/Speech/Speakable\ Items/Application\ Speakable\ Items/Google\ Chrome/
sudo rm ~/Library/Google/Google\ Chrome\ Brand.plist
sudo rm ~/Library/LaunchAgents/com.google.keystone.agent.plist
sudo rm ~/Library/Preferences/com.google.Keystone.Agent.plist
sudo rm -rf ~/Library/Caches/com.google.Keystone*
sudo rm -rf ~/Library/Caches/com.google.SoftwareUpdate
sudo rm ~/Library/Application\ Support/Google/RLZ
sudo rm -rf ~/Applications/Chrome\ Apps

sudo rm -rf ~/Library/Application\ Support/Google/Chrome

echo "Now we will reinstall Google Chrome for you, hang tight"
sudo jamf policy -event installChrome
sudo jamf recon

echo "This script is complete and you may sign into Google Chrome. Opening Google Chrome now..."
open -a Google\ Chrome.app

exit 0