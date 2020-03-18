#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(processId envId current version)
JSON_FILE=json/queryDeployment.json
URL=$baseURL/Deployment/query
id=result[0].id
exportVariable=deploymentId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON

callAPI

if [ $current = "false" ]  || [ $current = false ]
then
		jq --argjson version $version '.result[] | select (.version == $version)' out.json > out1.json
    export ${exportVariable}=`jq -r .id out1.json` 
fi

if [ ! -z "$deploymentId" ]
then
  curl -s -u $authToken -H "${h1}" -H "${h2}" $baseURL/Deployment/$deploymentId > out.json
  export digest=`jq -r .digest out.json` 
fi

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
