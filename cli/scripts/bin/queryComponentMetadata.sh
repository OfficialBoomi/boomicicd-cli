#!/bin/bash

unset saveComponentId saveComponentType saveComponentName saveComponentVersion
source bin/common.sh
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

JSON_FILE=json/queryComponentMetadata
# Create the JSON File with either componentType and (componentId or processName)

if [ ! -z "${componentType}" ] && [ null != "${componentType}" ]
then

	if [ ! -z "${componentId}" ] && [ null != "${componentId}" ]
	then
  	ARGUMENTS=(componentId componentType deleted currentVersion)
  	JSON_FILE="${JSON_FILE}ComponentIdComponentType"
	else
  	ARGUMENTS=(componentName componentType deleted currentVersion)
  	JSON_FILE="${JSON_FILE}ComponentNameComponentType"
	fi
else

  if [ ! -z "${componentId}" ] && [ null != "${componentId}" ]
  then
   ARGUMENTS=(componentId deleted currentVersion)
   JSON_FILE="${JSON_FILE}ComponentId"
  else
   ARGUMENTS=(componentName deleted currentVersion)
   JSON_FILE="${JSON_FILE}ComponentName"
  fi

fi

JSON_FILE="${JSON_FILE}.json"
URL=$baseURL/ComponentMetadata/query
createJSON

callAPI

extract result[0].componentId saveComponentId
extract result[0].name saveComponentName
extract result[0].version saveComponentVersion
extract result[0].type saveComponentType

clean

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

export componentId="${saveComponentId}"
export componentType="${saveComponentType}"
export componentName="${saveComponentName}"
export componentVersion="${saveComponentVersion}"
unset saveComponentId saveComponentType saveComponentName saveComponentVersion
