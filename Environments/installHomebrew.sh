#!/bin/sh

ConsoleUser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"
tempAdminStatus=false


#Check to See if user is an admin or not. Makes the a temporary admin and set tempAdminStatus for removal later
if groups $ConsoleUser | grep -q -w admin;
then
    echo "User is an admin"
else
    echo "User is not an admin"
    echo "Setting as temp admin"
    tempAdminStatus=true
    dscl . -append /Groups/admin GroupMembership $ConsoleUser
fi


# If XCode is missing we will install the Command Line tools only as that's all Homebrew needs
# Check to see if we have XCode already
# Installing the Xcode command line tools on 10.7.x or higher (Original code from https://github.com/rtrouton/rtrouton_scripts)

checkForXcode=$( pkgutil --pkgs | grep com.apple.pkg.CLTools_Executables | wc -l | awk '{ print $1 }')

# If XCode is missing we will install the Command Line tools only as that's all Homebrew needs

if [[ "$checkForXcode" != 1 ]]; then
    echo "Command Line tools are not installed. Will attempt to install."
    macos_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')
    cmd_line_tools_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

    # Installing the latest Xcode command line tools on 10.9.x or higher

    if [[ "$macos_vers" -ge 9 ]]; then

      # Create the placeholder file which is checked by the softwareupdate tool 
      # before allowing the installation of the Xcode command line tools.

      touch "$cmd_line_tools_temp_file"

      # Identify the correct update in the Software Update feed with "Command Line Tools" in the name for the OS version in question.

      if [[ "$macos_vers" -ge 15 ]]; then
        cmd_line_tools=$(softwareupdate -l | awk '/\*\ Label: Command Line Tools/ { $1=$1;print }' | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 9-)   
      elif [[ "$macos_vers" -gt 9 ]] && [[ "$macos_vers" -le 14 ]]; then
        cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "$macos_vers" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
      elif [[ "$macos_vers" -eq 9 ]]; then
        cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "Mavericks" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
      fi

      # Check to see if the softwareupdate tool has returned more than one Xcode
      # command line tool installation option. If it has, use the last one listed
      # as that should be the latest Xcode command line tool installer.

      if (( $(grep -c . <<<"$cmd_line_tools") > 1 )); then
        cmd_line_tools_output="$cmd_line_tools"
        cmd_line_tools=$(printf "$cmd_line_tools_output" | tail -1)
      fi

      #Install the command line tools

      softwareupdate -i "$cmd_line_tools" --verbose

      # Remove the temp file

      if [[ -f "$cmd_line_tools_temp_file" ]]; then
        rm "$cmd_line_tools_temp_file"
      fi
    fi
    xcode-select -s /Library/Developer/CommandLineTools   
else
  echo "Command Lines Tools are already installed"
fi


# Test if Homebrew is installed and install it if it is not
if test ! -f /usr/local/Homebrew/bin/brew ; then
  # Jamf will have to execute all of the directory creation functions Homebrew normally does so we can bypass the need for sudo
  echo "Creating folder structure for brew and setting correct permissions."
  /bin/chmod u+rwx /usr/local/bin
  /bin/chmod g+rwx /usr/local/bin
  /bin/mkdir -p /usr/local/Homebrew /usr/local/Homebrew/bin /usr/local/Homebrew/etc /usr/local/Homebrew/include /usr/local/Homebrew/lib /usr/local/Homebrew/sbin /usr/local/Homebrew/share /usr/local/Homebrew/var /usr/local/Homebrew/opt /usr/local/Homebrew/share/zsh /usr/local/Homebrew/share/zsh/site-functions /usr/local/Homebrew/var/homebrew /usr/local/Homebrew/var/homebrew/linked /usr/local/Homebrew/Cellar /usr/local/Homebrew/Caskroom /usr/local/Homebrew/Frameworks
  /bin/chmod 755 /usr/local/Homebrew/share/zsh /usr/local/Homebrew/share/zsh/site-functions
  /bin/chmod g+rwx /usr/local/Homebrew/bin /usr/local/Homebrew/etc /usr/local/Homebrew/include /usr/local/Homebrew/lib /usr/local/Homebrew/sbin /usr/local/Homebrew/share /usr/local/Homebrew/var /usr/local/Homebrew/opt /usr/local/Homebrew/share/zsh /usr/local/Homebrew/share/zsh/site-functions /usr/local/Homebrew/var/homebrew /usr/local/Homebrew/var/homebrew/linked /usr/local/Homebrew/Cellar /usr/local/Homebrew/Caskroom /usr/local/Homebrew /usr/local/Homebrew/Frameworks
  /bin/chmod 755 /usr/local/Homebrew/share/zsh /usr/local/Homebrew/share/zsh/site-functions
  /usr/sbin/chown $ConsoleUser /usr/local/Homebrew/bin /usr/local/Homebrew/etc /usr/local/Homebrew/include /usr/local/Homebrew/lib /usr/local/Homebrew/sbin /usr/local/Homebrew/share /usr/local/Homebrew/var /usr/local/Homebrew/opt /usr/local/Homebrew/share/zsh /usr/local/Homebrew/share/zsh/site-functions /usr/local/Homebrew/var/homebrew /usr/local/Homebrew/var/homebrew/linked /usr/local/Homebrew/Cellar /usr/local/Homebrew/Caskroom /usr/local/Homebrew /usr/local/Homebrew/Frameworks
  /usr/bin/chgrp admin /usr/local/Homebrew/bin /usr/local/Homebrew/etc /usr/local/Homebrew/include /usr/local/Homebrew/lib /usr/local/Homebrew/sbin /usr/local/Homebrew/share /usr/local/Homebrew/var /usr/local/Homebrew/opt /usr/local/Homebrew/share/zsh /usr/local/Homebrew/share/zsh/site-functions /usr/local/Homebrew/var/homebrew /usr/local/Homebrew/var/homebrew/linked /usr/local/Homebrew/Cellar /usr/local/Homebrew/Caskroom /usr/local/Homebrew /usr/local/Homebrew/Frameworks
  /bin/mkdir -p /Users/$ConsoleUser/Library/Caches/Homebrew
  /bin/chmod g+rwx /Users/$ConsoleUser/Library/Caches/Homebrew
  /usr/sbin/chown $ConsoleUser /Users/$ConsoleUser/Library/Caches/Homebrew
  /bin/mkdir -p /Library/Caches/Homebrew
  /bin/chmod g+rwx /Library/Caches/Homebrew
  /usr/sbin/chown $ConsoleUser /Library/Caches/Homebrew

  # Install Homebrew as the currently logged in user
  echo "Starting Homebrew install"
  su $ConsoleUser -c "curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /usr/local/Homebrew"
# If Homebrew is already installed then just echo that it is already installed
else
  echo "Homebrew is already installed"
fi


# Checks tempAdminStatus and removes admin rights if needed. 
if [ "$tempAdminStatus" = true ] ; then
  dscl . -delete /Groups/admin GroupMembership $ConsoleUser
  echo "Admin rights removed"
fi

#A dd the Homebrew directory to PATH
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
