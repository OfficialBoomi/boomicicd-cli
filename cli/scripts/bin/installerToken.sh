#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomType)
JSON_FILE=json/installerToken.json
URL=$baseURL/InstallerToken
id=token
exportVariable=tokenId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON
 
callAPI
 
clean
