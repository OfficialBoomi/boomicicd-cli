#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomId envId)
JSON_FILE=json/createAtomAttachment.json
URL=$baseURL/EnvironmentAtomAttachment/
id=id
exportVariable=atomAttachmentId

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
