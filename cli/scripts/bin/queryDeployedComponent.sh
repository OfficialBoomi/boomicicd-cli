#!/bin/bash
set -e 
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(envId componentId)
JSON_FILE=json/queryDeployedComponent.json
URL=$baseURL/DeployedPackage/query
id=result[0].deploymentId
exportVariable=deploymentId
unset deploymentId
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON
 
callAPI
 
clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
