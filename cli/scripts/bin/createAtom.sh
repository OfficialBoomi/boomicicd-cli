#!/bin/bash

source bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomName cloudId)
inputs "$@"

if [ "$?" -gt "0" ]
then
   return 255;
fi
 
saveAtomName="${atomName}"
source bin/queryAtom.sh atomName="${atomName}" atomType="*" atomStatus="*"

if [ "$?" -gt "0" ]
then
   return 255;
fi

ARGUMENTS=(atomName cloudId)
JSON_FILE=json/createAtom.json
URL=$baseURL/Atom
id=id
exportVariable=atomId
export atomName=${saveAtomName}

if [ -z "${atomId}" ] || [ "${atomId}" == "null" ] 
then 
	
	createJSON
	callAPI

fi

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
