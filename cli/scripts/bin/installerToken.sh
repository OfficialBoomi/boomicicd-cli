#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomType)
OPT_ARGUMENTS=(cloudId)
JSON_FILE=json/installerToken.json
URL=$baseURL/InstallerToken
id=token
exportVariable=tokenId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

if [ ! -z "$cloudId" ]
then
	saveCloudId=$cloudId
	ARGUMENTS=(atomType cloudId)
  JSON_FILE=json/installerTokenCloud.json
fi

createJSON
 
callAPI
 
clean

#export cloudId=$saveCloudId
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
