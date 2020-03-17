#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(roleName)
JSON_FILE=json/queryRole.json
URL=$baseURL/Role/query
id=result[0].id
exportVariable=roleId

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
