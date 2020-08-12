#!/usr/bin/env bash

# The following script allows IT to quickly and easily gather information
# required for audit-purposes from employee computers.
#
# The script gathers information such as a user's machine asset tag number,
# logged-in user account name, computer hostname, serial number, encryption
# status, OS X/macOS version, installed user and device profiles, black-listed
# applications, applications that we are curious about installed version,
# packages installed via: Homebrew and their versions, packages installed via:
# Nix and their versions, and a list of Apple security updates/patches. It then
# converts the report into a PDF file and automatically uploads it to the office
# NAS. 
# 
# This script is a basic shell/bash (.sh) script but with a .command extension.
# This allows for a user on a Mac OS X/macOS computer to run by simply double-
# clicking on the script. Also note that the executable bit is enabled in order
# for this to function in this way.

# Ensure that user is not running the script as sudo
if [ `whoami` = "root" ]; then
    echo "Please re-run this script without sudo."
    exit 1;
fi

# Array list for anti-virus application
declare -a anti_virus_application_list=("kaspersky" "kav")

# Array list for tracked applications
declare -a tracked_application_list=("google chrome" "firefox" "safari" "java" \
"flash" "hipchat" "omnigraffle" "cyberduck" "xcode" "filezilla" \
"lastpass" "dropbox" "box sync" "sketch" "virtualbox" "sublime" "adobe" \
"microsoft" "iterm" "textwrangler" "balsamiq" "vmware" "silverlight" "opera" \
"itunes" "thunderbird" "google drive")

# Array list for black-listed applications
declare -a blacklisted_application_list=("bittorrent" "transmission" \
"utorrent" "qbittorrent" "deluge" "vuze" "xtorrent" "bitrocket" "wireshark" \
"boinc" "@home" "burp" "metasploit" "packetpeeper" "arachni" "w3af" "vega" \
"canvas")

# Counter is used when prompting the user to enter the Asset Tag Number
counter=0

# "is_local" variable is used to determine if user needs to save report locally
is_local=0

# Create variable for resulting file name using the logged in username
username="$(logname)"
resulting_file=$username"_audit_results"

# Provide feedback in case curl takes a long time or times-out
echo "Please wait..."

# Confirm that user is on the correct wireless network ("[companyname]") and
# is able to connect to the NAS
curl 10.0.8.40 --connect-timeout 5 -s >> /dev/null

if [ $? != 0 ]; then
    echo
    echo "Unable to connect to the NAS. Please confirm that you are currently"\
    "located in the Chicago office, that you are connected to the"\
    "\"[companyname]\" wireless network, and attempt to run this script"\
    "again. See IT if issues persist."
    echo
    echo "Optionally, you can save the report locally and manually email it"\
    "to [support email] (only recommended for remote employees)." 
    read -p "Would you like to choose this option? (y/N): " response

    if [[ $response =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
    	is_local=1
    else
    	echo "Script is exiting. Please attempt to run this script again and"\
    	"see I.T. if you have any questions."
    	exit 1;
    fi
fi

# Get user-inputted asset tag number immediately to avoid lengthy waits for the
# user
read -p "Please enter your computer's asset tag number (example format: "\
"\"[assettagexample]\"): " asset_tag_number

until [[ $asset_tag_number = [Nn][Ss][0-9][0-9][0-9][0-9] ]]; do
	if [[ $counter -ge 2 ]]; then
		echo "Asset Tag Number format is invalid. Please try the script again"\
		"or see IT"
		exit 1;
	fi
	read -p "Asset Tag Number format is invalid (example format: \"[assettagexample]\").\
	Please try again: " asset_tag_number
	(( counter++ ))
done

# Create $resulting_file.txt
touch $resulting_file.txt

# Get date
echo Date: > $resulting_file.txt
echo >> $resulting_file.txt
date >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get username
echo Username: >> $resulting_file.txt 
echo >> $resulting_file.txt
logname >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get uid
echo Uid: >> $resulting_file.txt
echo >> $resulting_file.txt
id | awk '/uid/ {print $1}' >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get hostname
echo Hostname: >> $resulting_file.txt
echo >> $resulting_file.txt
hostname >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get machine serial number
echo Computer Serial Number: >> $resulting_file.txt
echo >> $resulting_file.txt
system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' >> \
$resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Print asset tag number into report
echo Asset Tag Number: >> $resulting_file.txt
echo >> $resulting_file.txt
echo $asset_tag_number | awk '{ print toupper($0) }' >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get Machine MAC addresses
echo "Machine Interface MAC Addresses:" >> $resulting_file.txt
echo >> $resulting_file.txt
for interface in "en0" "en1" "en2" "en3" "en4" "en5" "en6" "en7" "en8"
do
	ifconfig $interface &>/dev/null
	if [ $? = 0 ]; then
		echo "Interface "$interface":" >> $resulting_file.txt
		ifconfig $interface | awk '/ether/ {print $2}' >> $resulting_file.txt
		echo >> $resulting_file.txt
	fi
done
echo >> $resulting_file.txt

# Get encryption status/type
# Note: macOS 10.12.x has slightly different diskutil formatting
if [[ `sw_vers -productVersion` = 10.12.[0-9] ]]; then
	echo Encryption Status: >> $resulting_file.txt
	echo >> $resulting_file.txt
	diskutil list | grep -B 3 Encrypted | awk '/0:/ {print $2, $3} /Encrypted/ \
	{print $2,"\n"}' >> $resulting_file.txt
	echo >> $resulting_file.txt
else
	echo Encryption Status: >> $resulting_file.txt
	echo >> $resulting_file.txt
	diskutil list | grep -B 3 Encrypted | awk '/0:/ {print $3, $4} /Encrypted/ \
	{print $2,"\n"}' >> $resulting_file.txt
	echo >> $resulting_file.txt
fi

# Get macOS version
echo OS Version: >> $resulting_file.txt
echo >> $resulting_file.txt
sw_vers >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Inform user of prompt for entering their password
echo "Please enter your network account password (i.e. the password that you "\
"use to log into your computer):"

# Get all installed user and device profiles
echo All Currently Installed User and Device Profiles: >> $resulting_file.txt
echo >> $resulting_file.txt
sudo profiles -P >> $resulting_file.txt
if [ $? != 0 ]; then
    echo
    echo "You have failed to correctly enter your user account password."\
    "Please attempt to run the script again and/or contact I.T. if the issue"\
    "persists."
    echo
    rm $resulting_file.txt
    exit 1;
fi
echo >> $resulting_file.txt
echo >> $resulting_file.txt

echo "Please wait..."

# Create txt of all applications (used for tracked and blacklisted applications)
system_profiler SPApplicationsDataType > all_applications.txt

# Get Anti-Virus information
echo "Anti-Virus Status:" >> $resulting_file.txt
echo >> $resulting_file.txt
for anti_virus_application in "${anti_virus_application_list[@]}"
do
	cat all_applications.txt | grep -A 2 -E -i \
	"$anti_virus_application[0-9a-zA-Z ]{0,}:$" | grep -E -i \
	"$anti_virus_application|Version:" >> $resulting_file.txt
	if [ $? = 0 ]; then
		echo >> $resulting_file.txt
	fi
done
echo >> $resulting_file.txt

# Get tracked Applications
echo "Tracked Application Versions:" >> $resulting_file.txt
echo >> $resulting_file.txt
for tracked_application in "${tracked_application_list[@]}"
do
	cat all_applications.txt | grep -A 2 -E -i \
	"$tracked_application[0-9a-zA-Z ]{0,}:$" | grep -E -i \
	"$tracked_application|Version:" >> $resulting_file.txt
	if [ $? = 0 ]; then
		echo >> $resulting_file.txt
	fi
done
echo >> $resulting_file.txt

# Get Additional Version information over packages that we are curious about
echo "Additional Version Information for Select Packages That we are Curious "\
"About:" >> $resulting_file.txt
echo >> $resulting_file.txt
openssl version >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get blacklisted/not-approved Applications
echo "Blacklisted/Not-Approved Applications:" >> $resulting_file.txt
echo >> $resulting_file.txt
for blacklisted_application in "${blacklisted_application_list[@]}"
do
	cat all_applications.txt | grep -A 2 -E -i \
	"$blacklisted_application[0-9a-zA-Z ]{0,}:$" | grep -E -i \
	"$blacklisted_application|Version:" >> $resulting_file.txt
	if [ $? = 0 ]; then
		echo >> $resulting_file.txt
		echo "    Exempt:  ☐" >> $resulting_file.txt
		echo >> $resulting_file.txt
		echo >> $resulting_file.txt
	fi
done
echo >> $resulting_file.txt

# Clean-up/remove all_applications.txt
rm all_applications.txt

# Get list of all packages installed via: HomeBrew
echo All Packages Installed From HomeBrew: >> $resulting_file.txt
echo >> $resulting_file.txt
if [ $(which brew) ]; then
	brew list --versions >> $resulting_file.txt
fi
echo >> $resulting_file.txt

# Get list of outdated HomeBrew packages
echo Outdated HomeBrew Packages: >> $resulting_file.txt
echo >> $resulting_file.txt
if [ $(which brew) ]; then
	brew outdated --verbose >> $resulting_file.txt
fi
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get list of all packages installed via: Nix
echo All Packages Installed From Nix: >> $resulting_file.txt
echo >> $resulting_file.txt
if [ $(which nix-env) ]; then
	nix-env -q >> $resulting_file.txt
fi
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Get list of Apple security updates installed
echo Apple Security Updates Installed: >> $resulting_file.txt
echo >> $resulting_file.txt
system_profiler SPInstallHistoryDataType | grep -A 5 -i "security update" | \
awk '!/--/' >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt

# Print Approved/Needs Review check-boxes and "Reviewed By:" line
echo >> $resulting_file.txt
echo >> $resulting_file.txt
echo "Approved:      ☐" >> $resulting_file.txt
echo "Needs Review:  ☐" >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt
echo >> $resulting_file.txt
echo "Reviewed By: __________________________________________________________"\
"_________" >> $resulting_file.txt

# Convert $resulting_file.txt into $resulting_file.pdf using cupsfilter utility
cupsfilter $resulting_file.txt > $resulting_file.pdf 2>/dev/null

if [ $? = 0 ]; then
	rm $resulting_file.txt
else
	echo
	echo "An error occurred while attempting to generate the PDF report."\
	" Please try running this script again and/or contact I.T."
	echo
	rm $resulting_file.txt
	exit 1;
fi

if [[ $is_local != 1 ]]; then
	# Rsync the resulting PDF file to the NAS
	rsync ./$resulting_file.pdf 10.0.8.40::audit_repo

	if [ $? = 0 ]; then
		rm $resulting_file.pdf
	else
		echo
		echo "An error occurred while attempting to upload the PDF report to "\
		"the NAS. Please confirm that you are currently located in the Chicago"\
		" office, that you are connected to \"[companyname]\", attempt to "\
		"run this script again, and/or contact I.T."
		echo
		rm $resulting_file.pdf
		exit 1;
	fi
else
	mv $resulting_file.pdf ~/Downloads/
	echo
	echo "\""$resulting_file".pdf\" has been placed in your \"Downloads\""\
	"folder. Please send this file to [support email]. Script"\
	"has finished. Feel free to quit out of Terminal (Terminal -> Quit"\
	"Terminal or Command + Q)."
	echo
	exit 1;
fi

echo "Script has finished. Feel free to quit out of Terminal (Terminal -> "\
"Quit Terminal or Command + Q)."
