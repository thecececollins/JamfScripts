#!/bin/sh

####################################################
## Remove Existing Meraki Components and Unenroll MDM
####################################################

launchctl unload /Library/LaunchDaemons/com.meraki.agentd.plist
/bin/rm -f /usr/sbin/m_agent /usr/sbin/m_agent_upgrade
/bin/rm -rf '/Library/Application Support/Meraki/'
/bin/rm -f /Library/LaunchDaemons/com.meraki.agentd.plist

/usr/bin/profiles -R -p com.meraki.sm.mdm


exit 0
exit 1
