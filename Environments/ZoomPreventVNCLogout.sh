#!/bin/bash

##This script prevents Zoom from logging out of VNC and preventing remote TechOps from remote supporting Zoom Room devices
sudo defaults write /Library/Preferences/com.apple.RemoteManagement RestoreMachineState -bool NO
