#!/bin/bash

    bundle="Backup and Sync.app"
    tmp="/private/tmp/GoogleBackupAndSync"

    echo "$(date): Create temporary directory"
    mkdir -p "${tmp}"

    echo "$(date): Download 'https://dl.google.com/drive/InstallBackupAndSync.dmg'"
    curl -s -o  "${tmp}"/"InstallBackupAndSync.dmg" "https://dl.google.com/drive/InstallBackupAndSync.dmg"

    echo "$(date): Check downloaded DMG"
    volume=$(hdiutil attach -noautoopen -noverify -nobrowse "${tmp}/InstallBackupAndSync.dmg" | egrep "Volumes" | grep -o "/Volumes/.*")

    if [ "$(find "${volume}" -name "${bundle}" -execdir echo '{}' ';' -print | sed -n 1p)" == "${bundle}" ]; then

        bundlepath=$(find "${volume}" -name "${bundle}" -print | sed -n 1p)
        bundlename=$(find "${volume}" -name "${bundle}" -execdir echo '{}' ';' -print | sed -n 1p)
        echo "$(date): '${bundle}' was found in '${bundlepath}'"

        if [ ! -s "${bundlepath}" ]; then

            echo "$(date): No bundle found"
            rm -rf "${tmp}"
            hdiutil detach $(/bin/df | /usr/bin/grep "${volume}" | awk '{print $1}') -quiet -force
            exit 1

        else

            if [ -s "/Applications/${bundle}" ]; then

                echo "$(date): Delete installed '${bundle}'"
                rm -rf "/Applications/${bundle}"

            fi

            echo "$(date): Move '${bundlepath}' to '/Applications'"
            rsync -ar "${bundlepath}" "/Applications/"

        fi

        echo "$(date): Unmount '${volume}'"
        hdiutil detach $(/bin/df | /usr/bin/grep "${volume}" | awk '{print $1}') -quiet -force

        echo "$(date): Purge temporary directory"
        rm -rf "${tmp}"

    else

        rm -rf "${tmp}"
        exit 1

    fi

exit 0

open -a /Applications/Backup\ and\ Sync.app
