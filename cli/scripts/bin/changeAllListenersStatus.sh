# changeAllListenerStatus - can be used to pause, resume, or restart all listeners(AtomQueue/JMS/Webservice Listener) 
# Usage : 
# changeAllListenerStatus atomId action (pause_all|resume_all|restart_all)
#!/bin/bash
#sed -e "s/\${atomId}/$1/" -e  "s/\${action}/$2/" changeAllListenersStatus.json > tmp_cls_all.json
#curl -X POST -u "$authToken" -H "${h1}" -H "${h2}" $baseURL/changeListenerStatus -d@tmp_cls_all.json > out.json
source bin/common.sh

ARGUMENTS=(atomName atomType action)

inputs "$@"

if [ "$?" -gt "0" ]
then
        return 255;
fi

source bin/queryAtom.sh atomName="$atomName" atomStatus=online atomType=$atomType

ARGUMENTS=(atomId action)
JSON_FILE=json/changeAllListenersStatus.json
URL=$baseURL/changeListenerStatus

createJSON

callAPI

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
