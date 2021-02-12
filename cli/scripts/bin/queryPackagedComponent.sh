#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(componentId componentType packageVersion)
OPT_ARGUMENTS=(componentVersion)
URL=$baseURL/PackagedComponent/query
id=result[0].packageId
exportVariable=packageId
unset packageId
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

if [ ! -z "${packageId}" ] && [ "${packageId}" != "null" ] && [ "${packageId}" != null ]
then
	echoi "Found packageId ${packageId} for componentId ${componentId} with packageVersion ${packageVersion}. This package will not be recreated."
fi
 
clean
if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
