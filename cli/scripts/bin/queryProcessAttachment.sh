#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(processId envId componentType)
JSON_FILE=json/queryProcessAttachment.json
URL=$baseURL/ProcessEnvironmentAttachment/query
id=result[0].id
exportVariable=processAttachmentId

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
