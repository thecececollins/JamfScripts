#!/bin/bash

# This is just for the debugging phases...
set -x
set -e

# Root user detection
if [ $(echo "$UID") = "0" ]; then
	sudo_cmd=''
else
	sudo_cmd='sudo'
fi

API_KEY=${API_KEY:-$CONTROL_NODE_ID}
HOST_ID=1e2da92b-69ec-40a4-971f-57f25cc0004c
BASE=/private/var/osquery
SECRETFILE="${BASE}/secret"

if [ -z "${API_KEY}" ]; then
	if [ -f "${SECRETFILE}" ]; then
		API_KEY=$($sudo_cmd cat "${SECRETFILE}")
	fi
fi

if [ -z "${API_KEY}" ]; then
	echo "You must supply either the API_KEY or CONTROL_NODE_ID environment variable to identify your agent account"
	exit 1
fi


echo "Downloading image"
curl -s "https://s3-us-west-2.amazonaws.com/prod-otxb-portal-osquery/repo/osx/alienvault-agent-19.07.0803.0301.pkg" > /tmp/osquery.pkg

echo "Installing image"
$sudo_cmd installer -verbose -pkg /tmp/osquery.pkg -target /

echo "Deleting image"
$sudo_cmd rm /tmp/osquery.pkg

echo "Writing secret"
$sudo_cmd bash -c "echo ${API_KEY} > ${SECRETFILE}"
$sudo_cmd chmod go-rwx ${SECRETFILE}

echo "Setting up flag file"
FLAGFILE="${BASE}/osquery.flags"

if [ -z "${HOST_ID}" ]; then
	if [ -f "${FLAGFILE}" ]; then
		HOST_ID=$(grep specified_identifier ${FLAGFILE} | sed s/--specified_identifier=//)       
	fi

	if [ -z "${HOST_ID}" ]; then
		HOST_ID=00000000-394f-46dd-8642-a069f006458d
	else
		echo "Detected and re-using previously selected host id from $FLAGFILE: $HOST_ID"  
	fi
fi

$sudo_cmd cp ${BASE}/osquery.flags.example ${FLAGFILE}

echo "Setting host identifier"
$sudo_cmd bash -c "echo --tls_hostname=api.agent.alienvault.cloud/osquery-api/us-east-1 >> ${FLAGFILE}"
$sudo_cmd bash -c "echo --host_identifier=specified >> ${FLAGFILE}"
$sudo_cmd bash -c "echo --specified_identifier=${HOST_ID} >> ${FLAGFILE}"

alienvault-agent.sh restart