
#!/bin/bash

COUNTER=0

until [ $COUNTER -gt 9000 ];
do
	date >> /tmp/processlist.txt
	/usr/local/mysql/bin/mysqladmin -u root processlist >> /tmp/processlist.txt
	echo "" >> /tmp/processlist.txt
        echo "" >> /tmp/processlist.txt
	COUNTER=$[$COUNTER+1]
	sleep 1
done
