#!/bin/sh
SUList=`softwareupdate -l | grep "*" | sed "s/\*//g" | sed "s/$/,/g"`
echo "<result>$SUList</result>"
