#!/bin/bash
source bin/common.sh
# Query processattachment id before creating it
source bin/queryPackagedComponent.sh $@


# mandatory arguments
ARGUMENTS=(componentId componentType packageVersion notes createdDate)
createdDate=`date -u +"%Y-%m-%d"T%H:%M:%SZ`
JSON_FILE=json/createPackagedComponent.json
URL=$baseURL/PackagedComponent/
id=packageId
exportVariable=packageId
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON

if [ "$packageId" == "null" ] || [ -z "$packageId" ]
then 
	callAPI	
fi

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
