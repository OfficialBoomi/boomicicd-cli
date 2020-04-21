#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(componentId componentType packageVersion)
OPT_ARGUMENTS=(componentVersion)
URL=$baseURL/PackagedComponent/query
id=result[0].packageId
exportVariable=packageId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
# if [ -z "${componentVersion}" ] || [ "" == "${componentVersion}" ] || [ null == "${componentVersion}" ] || [ "null" == "${componentVersion}" ]
#then
# JSON_FILE=json/queryPackagedComponent.json
#else
# ARGUMENTS=(componentId componentType packageVersion componentVersion)
# JSON_FILE=json/queryPackagedComponentComponentVersion.json
# fi

JSON_FILE=json/queryPackagedComponent.json
createJSON
 
callAPI
 
clean
if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
