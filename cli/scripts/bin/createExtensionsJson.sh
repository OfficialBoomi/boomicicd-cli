#!/bin/bash

source bin/common.sh
ARGUMENTS=componentFile
inputs "$@"


if [ -z "${extensionJson}" ] 
then 
	JSON_FILE=json/ExtensionTemplate.json
	json=$(jq . ${JSON_FILE})
else
	json="${extensionJson}"

fi
index=$(echo ${json} | jq '.connections.connection | length')

componentXML=$( cat ${componentFile} | sed -e 's/bns://g' )
ConnectionOverrides=$( echo $componentXML | xmllint -xpath 'count(/Component/processOverrides/Overrides/Connections/ConnectionOverride)' -)

for (( h=1; h<=${ConnectionOverrides}; h++ ))
do
	l=$(( index + h - 1 ))
	connectionId=$(echo ${componentXML} | xmllint -xpath 'string(/Component/processOverrides/Overrides/Connections/ConnectionOverride['${h}']/@id)' -)
	connectionExists=$(echo "${extensionJson}" | jq --arg id ${connectionId} '.connections.connection[] | select(.id == $id)')
  
  # Add connection only if does not exist in the extensions
	if [ -z "${connectionExists}" ]
  then
		# adding a new connection to the index"
		componentId=$connectionId
		source bin/queryComponentMetadata.sh componentId=${componentId}
		json=$(echo ${json} | jq --arg componentName "${componentName}" --arg componentId ${connectionId} --arg connection_arg ${l} '.connections.connection[$connection_arg|tonumber] |= . + {"@type": "Connection", "field": [], "id": $componentId, "name": $componentName}')
		fields=$(echo ${componentXML} | xmllint -xpath 'count(/Component/processOverrides/Overrides/Connections/ConnectionOverride['${h}']/field[@overrideable="true"])' -)
  	for (( f=1; f<=${fields}; f++ ))
		do
	 		fieldId=$(echo ${componentXML} | xmllint -xpath 'string(/Component/processOverrides/Overrides/Connections/ConnectionOverride['${h}']/field[@overrideable="true"]['${f}']/@id)' -)
			if [[ $fieldId == "password" ]]
			then
				useEncryption="true"
		  else
			 useEncryption="false"
			fi
	 		_g=$(( f - 1 ))
	 		json=$(echo ${json} | jq --arg field $_g --arg id "${fieldId}" --arg connection_arg ${l} --arg useEncryption ${useEncryption} '.connections.connection[$connection_arg|tonumber].field[$field|tonumber]  |= . + {"@type": "field", "id": $id, "value": "", "usesEncryption": $useEncryption}')
		done
		unset componentId componentName componentType componentVersion
	fi
done

export extensionJson="$(echo ${json} | jq . )"
clean
