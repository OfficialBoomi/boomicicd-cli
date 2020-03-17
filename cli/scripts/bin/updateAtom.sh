#!/bin/bash
source bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomId purgeHistoryDays)
JSON_FILE=json/updateAtom.json
exportVariable=updatedAtomId
id=id
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

URL=$baseURL/Atom/$atomId/update
createJSON
 
callAPI
 
clean
export atomId=${updatedAtomId}
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
