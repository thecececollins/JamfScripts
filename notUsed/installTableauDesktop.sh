#!/bin/bash

    bundle="TableauDesktop-2019-2-0.dmg"
    tmp="/private/tmp/TableauDesktop"

    echo "$(date): Create temporary directory"
    mkdir -p "${tmp}"

    echo "$(date): Download 'https://www.tableau.com/downloads/desktop/mac'"
    curl -s -o  "${tmp}"/"TableauDesktop-2019-2-0.dmg" "https://www.tableau.com/downloads/desktop/mac"

    echo "$(date): Check downloaded DMG"
    volume=$(hdiutil attach -noautoopen -noverify -nobrowse "${tmp}/TableauDesktop-2019-2-0.dmg" | egrep "Volumes" | grep -o "/Volumes/.*")

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

    echo "$(date): Opening Application"
    open -a /Applications/Tableau\ Desktop.app

exit 0
