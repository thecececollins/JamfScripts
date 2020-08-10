#!/bin/sh
#########################################################################################
# A script to collect whwether the EFI Firmware password has been configured.           #
# If EFI Firmware password is not configured "Not Configured" will return back.         #
#########################################################################################

firmwarePass="$(firmwarepasswd -check)";
if [ "$firmwarePass" == "Password Enabled: Yes" ];then
	echo "<result>Configured</result>";
else
	echo "<result>Not Configured</result>"
fi