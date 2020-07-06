#!/bin/bash

# Process Schedule Status Query by passing the processId and atomId
# Usage : updateProcessScheduleStatus.sh <atomName> <atomType> <processId> <status=true|false>

source bin/common.sh
ARGUMENTS=(atomName enabled)
OPT_ARGUMENTS=(processName componentId atomType)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

if [ -z "${atomType}" ] || [ null == "${atomType}" ]
then
	atomType="*"
fi

if [ -z "${componentId}" ] || [ null == "${componentId}" ]
then
  source bin/queryProcess.sh processName="$processName"
fi

#Query Process Schedule Status  by atomId and processId
source bin/queryProcessScheduleStatus.sh atomName="$atomName" atomType=$atomType componentId="${componentId}"

saveScheduleId=${scheduleId}
status="${enabled}"

ARGUMENTS=(atomId processId scheduleId status)
JSON_FILE=json/updateProcessScheduleStatus.json
URL=$baseURL/ProcessScheduleStatus/$scheduleId/update
 
createJSON

unset exportVariable

callAPI

extract enabled saveEnabled

clean

export scheduleId=${saveScheduleId}

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

export enabled="${saveEnabled}"
