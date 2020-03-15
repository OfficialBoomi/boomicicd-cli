# executeProcess (asyncronously) by passing the processId and atomId
# Usage : executeProcess.sh <atomId> <processId>
#!/bin/bash
source bin/common.sh
#execute Process by atomId and processId
ARGUMENTS=(atomName atomType)
OPT_ARGUMENTS=(componentId processName)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

source bin/queryAtom.sh atomName="$atomName" atomStatus=online atomType=$atomType

if [ -z "${componentId}" ]
then
	source bin/queryProcess.sh processName="$processName"
fi
processId=${componentId}

ARGUMENTS=(atomId processId)
JSON_FILE=json/executeProcess.json
URL=$baseURL/executeProcess
 
createJSON

callAPI

clean
