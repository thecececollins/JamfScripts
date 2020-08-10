#!/bin/bash

	bundle="Google\ Backup\ and\ Sync\ from\ Google.app"
    tmp="/private/tmp/GoogleBackupandSync"

    echo "$(date -u): Creating temporary directory"
    mkdir -p "${tmp}"

    echo "$(date -u): Downloading 'https://dl.google.com/drive/InstallBackupAndSync.dmg'"
    curl -s -o  "${tmp}"/"GoogleBackupandSync.dmg" "https://dl.google.com/drive/InstallBackupAndSync.dmg"

    echo "$(date -u): Checking downloaded DMG"
    #volume=$(hdiutil attach -noautoopen -noverify -nobrowse "${tmp}/GoogleBackupandSync.dmg" | egrep "Volumes" | grep -o "/Volumes/.*")
   	hdiutil verify "${tmp}/GoogleBackupandSync.dmg"

	# Mounts the DMG so the PKG is accessible
   	sudo hdiutil attach "${tmp}/GoogleBackupandSync.dmg"


   	echo "$(date -u): Installing package"
   	sudo cp -R /Volumes/Install\ Backup\ and\ Sync\ from\ Google/Backup\ and\ Sync\ from\ Google.app\ /Applications
	#sudo installer -package /Volumes/Install Backup and Sync from Google/Backup and Sync from Google.pkg -target /

	echo "$(date -u): This may take a second or two..."
	sleep 15

	# Unmount the image
	echo "$(date -u): Unmounting DMG"
	sudo hdiutil detach "/Volumes/Install Backup and Sync from Google"

	echo "$(date -u): Purging temporary directory"
    rm -rf "${tmp}"


   # if [ "$(find "${volume}" -name "${bundle}" -execdir echo '{}' ';' -print | sed -n 1p)" == "${bundle}" ]; then

    #    bundlepath=$(find "${volume}" -name "${bundle}" -print | sed -n 1p)
    #    bundlename=$(find "${volume}" -name "${bundle}" -execdir echo '{}' ';' -print | sed -n 1p)
     #   echo "$(date -u): '${bundle}' was found in '${bundlepath}'"
#
 #       if [ ! -s "${bundlepath}" ]; then

#            echo "$(date -u): No bundle found"
 #           rm -rf "${tmp}"
  #          hdiutil detach $(/bin/df | /usr/bin/grep "${volume}" | awk '{print $1}') -quiet -force
   #         exit 1

    #    else

     #       if [ -s "/Applications/${bundle}" ]; then

#                echo "$(date -u): Deleting installed '${bundle}'"
 #               rm -rf "/Applications/${bundle}"

  #          fi

    #        echo "$(date -u): Moving '${bundlepath}' to '/Applications'"
   #         rsync -ar "${bundlepath}" "/Applications/"

     #   fi

      #  echo "$(date -u): Unmounting '${volume}'"
       # hdiutil detach $(/bin/df | /usr/bin/grep "${volume}" | awk '{print $1}') -quiet -force

        #echo "$(date -u): Purging temporary directory"
        #rm -rf "${tmp}"

  #  else

   #     rm -rf "${tmp}"
    #    exit 1

    #fi

    #echo "$(date -u): Opening Application"
   # open -a /Applications/Backup\ and\ Sync\ from\ Google.app

#exit 0
