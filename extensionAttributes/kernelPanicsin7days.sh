#!/bin/sh
#####################################################################################
# A script to collect show how many kernel panics have occurred in the last 7 days. #
#####################################################################################


PanicLogCount=$(find /Library/Logs/DiagnosticReports -Btime -7 -name *.panic | awk 'END{print NR}')
echo "<result>$PanicLogCount</result>"
