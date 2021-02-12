#!/bin/bash
source bin/common.sh
# Query processattachment id before creating it
source bin/queryPackagedComponent.sh "$@"


# mandatory arguments
ARGUMENTS=(componentId componentType packageVersion notes createdDate) 
OPT_ARGUMENTS=(componentVersion) 
createdDate=`date -u +"%Y-%m-%d"T%H:%M:%SZ`
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

if [ "${componentId}" == "null" ] || [ -z "${componentId}" ] || [ null == "${componentId}" ]
then
		echoe "Cannot create package for component ${componentId}."
		export packageId=""
        return 255;
fi

URL=$baseURL/PackagedComponent/
id=packageId
exportVariable=packageId

if [ null == "${componentVersion}" ]
then
 JSON_FILE=json/createPackagedComponent.json
else 
 ARGUMENTS=(componentId componentType componentVersion packageVersion notes createdDate) 
 JSON_FILE=json/createPackagedComponentVersion.json
fi

createJSON
if [ "$packageId" == "null" ] || [ -z "$packageId" ] || [ null == "${packageId}" ]
then 
	callAPI	
fi

clean
if [ "$ERROR" -gt 0 ]
then
   return 255;
fi

