#!/bin/bash

CONTROL_NODE_ID=1e2da92b-69ec-40a4-971f-57f25cc0004c bash -c "$(curl https://prod-api.agent.alienvault.cloud/osquery-api/us-east-1/bootstrap?flavor=pkg&version=19.07.0803.0301)"