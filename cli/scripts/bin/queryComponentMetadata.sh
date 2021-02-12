#!/bin/bash
source bin/common.sh

unset _saveComponentId _saveComponentType _saveComponentName _saveComponentVersion exportVariable
# mandatory arguments
OPT_ARGUMENTS=(componentType componentName componentId deleted currentVersion componentVersion)
ARGUMENTS=()
inputs "$@"

if [ "$?" -gt "0" ]
then
   return 255;
fi

if [ -z "${componentId}" ] && [ -z "${componentName}" ]
then
  export ERROR_MESSAGE="Either componentId or componentName must be used to query componentMetadata"
  export ERROR=255
  return ${ERROR}
else
	unset ERROR_MESSAGE ERROR
fi
   
# set defaults
if [ -z "${currentVersion}" ] 
then
	export currentVersion="true"
fi

if [ -z "${deleted}" ] 
then
	export deleted="false"
fi

ARGUMENTS=(componentId componentName componentType componentVersion deleted currentVersion)
JSON_FILE=json/queryComponentMetadata
# Create the JSON File with either componentType, componentVersion and (componentId or processName)

if [ ! -z "${componentId}" ]
then 
 JSON_FILE="${JSON_FILE}ComponentId"
else
 JSON_FILE="${JSON_FILE}ComponentName"
fi

if [ ! -z "${componentType}" ]
then 
 JSON_FILE="${JSON_FILE}ComponentType"
fi

if [ ! -z "${componentVersion}" ]
then 
	if [ ! -z "${componentId}" ]
	then
 		JSON_FILE="${JSON_FILE}ComponentVersion"
	else
		echov "Ignoring version if componentId is not specified"
	fi
fi


JSON_FILE="${JSON_FILE}.json"
URL=$baseURL/ComponentMetadata/query
createJSON

callAPI

extract result[0].componentId _saveComponentId
extract result[0].name _saveComponentName
extract result[0].version _saveComponentVersion
extract result[0].type _saveComponentType

clean

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

export componentId="${_saveComponentId}"
export componentType="${_saveComponentType}"
export componentName="${_saveComponentName}"
export componentVersion="${_saveComponentVersion}"
unset _saveComponentId _saveComponentType _saveComponentName _saveComponentVersion
