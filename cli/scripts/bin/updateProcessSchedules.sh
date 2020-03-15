# Process Schedules Query by passing the atomId, ProcessId, ScheduleId, schedule details as defined syntax
# Usage : updateProcessSchedules.sh <atomName> <atomType> <processName> <schedule: minutes hours daysOfWeek daysOfMonth months years>
###
# years		    - The standard year format(ex:2019). In most cases this is set to an asterisk [*].
# months	 	  - 1 is January and 12 is December. In most cases this is set to an asterisk [*].
# daysOfMonth	- 1 is the first day of the month and 31 is the last day of the month.
# daysOfWeek	- 1 is Sunday and 7 is Saturday.
# hours		    - A 24-hour clock is used. 0 is 12:00 A.M. or midnight and 12 is 12:00 P.M. or noon.
# minutes		  - 0 is the first minute of the hour — for example, 1:00 A.M.
#               59 is the last minute of the hour — for example, 1:59 A.M.
# maxRetry	  - (Retry schedules only) The maximum number of retries. The minimum valid value is 1; the maximum is 5.
###
#!/bin/bash

source bin/common.sh
#Query Process Schedule Status  by atomId and processId
ARGUMENTS=(atomName atomType processName years months daysOfMonth daysOfWeek hours minutes)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

source bin/queryProcessScheduleStatus.sh atomName="$atomName" atomType=$atomType processName="$processName"

echo $scheduleId

ARGUMENTS=(atomId processId scheduleId years months daysOfMonth daysOfWeek hours minutes)
JSON_FILE=json/updateProcessSchedules.json
URL=$baseURL/ProcessSchedules/$scheduleId/update
 
createJSON

callAPI

clean
