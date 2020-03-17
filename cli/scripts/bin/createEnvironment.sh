#!/bin/bash

source bin/common.sh
source bin/queryEnvironment.sh $@
return=($?)

if [ "$return" -gt "0" ]
then
   return 255;
fi

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env classification)
JSON_FILE=json/createEnvironment.json
URL=$baseURL/Environment
id=id
exportVariable=envId

if [ -z "$envId" ] || [ "$envId" == "null" ]
then
 
 inputs "$@"

 echo "Envirnoment not found, creating env: $env."
	
 createJSON
 
 callAPI
 
 clean
 
fi
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
