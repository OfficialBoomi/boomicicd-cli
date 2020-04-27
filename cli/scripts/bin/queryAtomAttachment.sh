#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomId)
OPT_ARGUMENTS=(envId)
URL=$baseURL/EnvironmentAtomAttachment/query
id=result[0].id
exportVariable=atomAttachmentId

inputs "$@"
if [ "$?" -gt "0" ] 
then 
	return 255;
fi

if [ ! -z "${envId}" ]
then
	JSON_FILE=json/queryAtomAttachmentEnv.json
  ARGUMENTS=(atomId envId)
else
	JSON_FILE=json/queryAtomAttachment.json
fi

createJSON
 
callAPI
extract result[0].atomId saveAtomId
extract result[0].environmentId saveEnvId

clean

export atomId=${saveAtomId}
export envId=${saveEnvId}
 
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
