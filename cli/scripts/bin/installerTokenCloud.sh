#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomType cloudId)
JSON_FILE=json/installerTokenCloud.json
URL=$baseURL/InstallerToken
id=token
exportVariable=tokenId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

saveCloudId=$cloudId
createJSON
 
callAPI
 
clean
export cloudId=$saveCloudId
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
