# Process Schedule Status Query by passing the processId and atomId
# Usage : updateProcessScheduleStatus.sh <atomName> <atomType> <processId> <status=true|false>
#!/bin/bash

source bin/common.sh
#Query Process Schedule Status  by atomId and processId
ARGUMENTS=(atomName atomType processName status)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

source bin/queryProcessScheduleStatus.sh atomName="$atomName" atomType=$atomType processName="$processName"

echo $scheduleId

ARGUMENTS=(atomId processId scheduleId status)
JSON_FILE=json/updateProcessScheduleStatus.json
URL=$baseURL/ProcessScheduleStatus/$scheduleId/update
 
createJSON

callAPI

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
