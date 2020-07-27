#!/bin/bash

if [ -e "/usr/local/bin/vagrant" ]
  then
	  vagrantVersion=$(vagrant -v | awk '{ print $NF}')
  else
	  vagrantVersion="Not Installed"
fi

echo "<result>$vagrantVersion</result>"
