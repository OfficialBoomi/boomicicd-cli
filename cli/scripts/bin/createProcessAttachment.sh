#!/bin/bash

source bin/common.sh
# Query processattachment id before creating it
source bin/queryProcessAttachment.sh $@
if [ "$?" -gt "0" ]
then
        return 255;
fi

# mandatory arguments
ARGUMENTS=(processId envId componentType)
JSON_FILE=json/createProcessAttachment.json
URL=$baseURL/ProcessEnvironmentAttachment/
id=id
exportVariable=processAttachmentId
inputs "$@"

createJSON

if [ "$processAttachmentId" == "null" ] || [ -z "$processAttachmentId" ]
then 
	callAPI
fi

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
