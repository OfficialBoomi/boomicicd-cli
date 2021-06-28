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

# Extract the component XML string and strip any namespace
componentXML=$( cat "${componentFile}" | sed -e 's/bns://g' )


# Scrape connection extensions from the component XML
f_addConnection=""
index_c=$(echo ${json} | jq '.extensionJson.connections.connection | length')
ConnectionOverrides=$( echo $componentXML | xmllint -xpath 'count(/Component/processOverrides/Overrides/Connections/ConnectionOverride)' -)
l=$index_c 
for (( h=1; h<=${ConnectionOverrides}; h++ ))
do
	connectionId=$(echo ${componentXML} | xmllint -xpath 'string(/Component/processOverrides/Overrides/Connections/ConnectionOverride['${h}']/@id)' -)
	componentId=$connectionId
	connectionExists=$(echo "${extensionJson}" | jq --arg id ${connectionId} '.extensionJson.connections.connection[] | select(.id == $id)')
	fields=$(echo ${componentXML} | xmllint -xpath 'count(/Component/processOverrides/Overrides/Connections/ConnectionOverride['${h}']/field[@overrideable="true"])' -)
	source bin/queryComponentMetadata.sh componentId=${componentId} componentVersion="" 
  # Add connection only if does not exist in the extensions and the componentName is not null or deleted and if there are fields in the connection
	if [ -z "${connectionExists}" ] && [ "${componentName}" != null ] && [ ${fields} -gt 0 ]
  then
			json=$(echo ${json} | jq --arg componentName "${componentName}" --arg componentId ${connectionId} --arg connection_arg ${l} '.extensionJson.connections.connection[$connection_arg|tonumber] |= . + {"@type": "Connection", "field": [], "id": $componentId, "name": $componentName}')
  		for (( f=1; f<=${fields}; f++ ))
			do
	 			fieldId=$(echo ${componentXML} | xmllint -xpath 'string(/Component/processOverrides/Overrides/Connections/ConnectionOverride['${h}']/field[@overrideable="true"]['${f}']/@id)' -)
	 			_g=$(( f - 1 ))
				if [[ $fieldId == "password" ]]
				then
                 useEncryption="true"
	 		  	 json=$(echo ${json} | jq --arg field $_g --arg id "${fieldId}" --arg connection_arg ${l} --arg useEncryption ${useEncryption} '.extensionJson.connections.connection[$connection_arg|tonumber].field[$field|tonumber]  |= . + {"@type": "field", "id": $id, "value": "#{}#", "usesEncryption": $useEncryption, "useDefault": false}')
		  	    else
			  	 useEncryption="false"
	 		  	 json=$(echo ${json} | jq --arg field $_g --arg id "${fieldId}" --arg connection_arg ${l} --arg useEncryption ${useEncryption} '.extensionJson.connections.connection[$connection_arg|tonumber].field[$field|tonumber]  |= . + {"@type": "field", "id": $id, "value": "", "usesEncryption": $useEncryption, "useDefault": false}')
				fi
			done
			l=$(( l + 1 ))
			f_addConnection="true"
	fi
  unset componentId componentName componentType componentVersion fields fieldId f _g
done

# Scrape dynamic properties extensions from the component XML
f_addProperty=""
index_p=$(echo ${json} | jq '.extensionJson.properties.property | length')
PropertyOverrides=$( echo $componentXML | xmllint -xpath 'count(/Component/processOverrides/Overrides/Properties/PropertyOverride)' -)
l=$index_p 
for (( h=1; h<=${PropertyOverrides}; h++ ))
do
	property=$(echo ${componentXML} | xmllint -xpath 'string(/Component/processOverrides/Overrides/Properties/PropertyOverride['${h}']/@name)' -)
	propertyExists=$(echo "${extensionJson}" | jq --arg name ${property} '.extensionJson.properties.property[] | select(.name == $name)')
  
  # Add property only if does not exist in the extensions
	if [ -z "${propertyExists}" ] && [ ! -z "${property}" ] && [ "${property}" != null ]
  then
		echov "Adding property ${property} at index $l"
	  json=$(echo ${json} | jq --arg name ${property} --arg property_arg ${l} '.extensionJson.properties.property[$property_arg|tonumber]  |= . + {"@type": "", "name": $name, "value": ""}')
		l=$(( l + 1 ))
		f_addProperty="true"
	fi
done


# export extension if there are atleast one field
if [ ! -z "${f_addConnection}" ] || [ ! -z "${f_addProperty}" ]  
 then 
	export extensionJson="$(echo ${json} | jq . )"
fi

unset json 
 
clean
