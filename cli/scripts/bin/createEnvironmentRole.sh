#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(roleName env)
inputs "$@"
if [ "$?" -gt "0" ] 
then 
	return 255;
fi
source bin/queryRole.sh name=$roleName
source bin/queryEnvironment.sh name=$envName classification="*"


ARGUMENTS=(roleId envId)
JSON_FILE=json/createEnvironmentRole.json
URL=$baseURL/EnvironmentRole/
id=id
exportVariable=roleattachmentId


createJSON
 
callAPI
 
clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
