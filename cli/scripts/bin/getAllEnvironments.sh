#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
URL=$baseURL/Environment/query
JSON_FILE=json/queryAny.json
createJSON
callAPI
mapfile -t names < <(jq -r .result[].name "${WORKSPACE}/out.json" | sort) 
i=0;
export envs=`while [ "$i" -lt "${#names[@]}" ]; do printf  "%s\n" "${names[$i]}"; i=$(( $i + 1 )); done`
	

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
