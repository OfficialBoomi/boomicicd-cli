# changeListenerStatus - can be used to pause, resume, or restart the listeners(AtomQueue/JMS/Webservice Listener) 
# Usage : 
# changeListenerStatus atomId listenerId action (pause|resume|restart)
#!/bin/bash

source bin/common.sh

ARGUMENTS=(atomName atomType action)
OPT_ARGUMENTS=(processName componentId)
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

listenerId=$componentId

ARGUMENTS=(atomId listenerId action)
JSON_FILE=json/changeListenerStatus.json
URL=$baseURL/changeListenerStatus

createJSON

callAPI
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
