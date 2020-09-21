# executeProcess (asyncronously) by passing the processId and atomId
# Usage : executeProcess.sh <atomId> <processId>
#!/bin/bash
source bin/common.sh
source bin/regression.sh
saveVerbose=${VERBOSE}
#unset VERBOSE

#execute Process by atomId and processId
ARGUMENTS=(atomName atomType)
OPT_ARGUMENTS=(componentId processName)


inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

exportVariable=atomId
source bin/queryAtom.sh atomName="$atomName" atomStatus=online atomType=$atomType

if [ -z "${componentId}" ]
then
	source bin/queryProcess.sh processName="$processName"
fi
processId=${componentId}

saveAccountId=${accountId}
saveAuthToken=${authToken}

ARGUMENTS=(atomId processId accountId authToken)
JSON_FILE=json/executeTestSuite.json
URL=$regressionTestURL/executeTestSuite

exportVariable=testSuiteExecutionId
id=testSuiteExecutionId

createJSON

callTestAPI

clean

export VERBOSE=${saveVerbose}
export accountId=${saveAccountId}
export authToken=${saveAuthToken}

unset saveAccountId saveAuthToken saveVerbose

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

