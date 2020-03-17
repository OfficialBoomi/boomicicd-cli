#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(processName)
JSON_FILE=json/queryProcess.json
URL=$baseURL/Process/query
id=result[0].id
exportVariable=processId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON

callAPI

extract $id componentId

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
