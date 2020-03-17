#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(componentId componentType packageVersion)
JSON_FILE=json/queryPackagedComponent.json
URL=$baseURL/PackagedComponent/query
id=result[0].packageId
exportVariable=packageId

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
