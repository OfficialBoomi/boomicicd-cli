#!/bin/bash

source bin/common.sh
ARGUMENTS=(atomName overrideUrl apiType auth url)
inputs "$@"

if [ "$?" -gt "0" ] 
then
        return 255;
fi
saveAtomName="${atomName}"

# get atom id of the by atom name
source bin/queryAtom.sh atomName="${atomName}" atomType="*" atomStatus="*"

if [ "$?" -gt "0" ] || [ -z "$atomId" ] || [ "$atomId" == "null" ]
then
        return 255;
fi

# mandatory arguments
ARGUMENTS=(atomId overrideUrl apiType auth url)
JSON_FILE=json/updateSharedServer.json
URL=$baseURL/SharedServerInformation/$atomId/update

printArgs

createJSON
 
callAPI

saveAtomId=${atomId}

clean

atomId=${saveAtomId}
atomName="${saveAtomName}"

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
