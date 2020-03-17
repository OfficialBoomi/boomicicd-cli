# changeListenerStatus - can be used to pause, resume, or restart the listeners(AtomQueue/JMS/Webservice Listener) 
# Usage : 
# changeListenerStatus atomId listenerId action (pause|resume|restart)
#!/bin/bash
#sed -e "s/\${atomId}/$1/" -e "s/\${listenerId}/$2/" -e "s/\${action}/$3/" changeListenerStatus.json > tmp_cls.json
#curl -X POST -u "$authToken" -H "${h1}" -H "${h2}" $baseURL/changeListenerStatus -d@tmp_cls.json > out.json

source bin/common.sh

ARGUMENTS=(atomName atomType processName  action)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

source bin/queryAtom.sh atomName="$atomName" atomStatus=online atomType=$atomType
echo $atomId
source bin/queryProcess.sh processName="$processName"
echo $componentId

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
