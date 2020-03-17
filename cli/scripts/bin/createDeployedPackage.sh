#!/bin/bash

source bin/common.sh 
# Query processattachment id before creating it
source bin/queryDeployedPackage.sh $@


# mandatory arguments
ARGUMENTS=(envId packageId notes listenerStatus)
JSON_FILE=json/createDeployedPackage.json
URL=$baseURL/DeployedPackage/
id=deploymentId
exportVariable=deploymentId
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
createJSON
 
if [ "$deploymentId" == "null" ] || [ -z "$deploymentId" ]
then 
	callAPI
fi

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
