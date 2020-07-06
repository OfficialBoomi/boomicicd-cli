#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(from to processName current version listenerStatus)
inputs "$@"
return=($?)

if [ "$return" -gt "0" ]
then
   return 255;
fi

source bin/queryEnvironment.sh env=$from classification="*"
fromEnvId=$envId

source bin/queryEnvironment.sh env=$to classification="*"
toEnvId=$envId

source bin/queryProcess.sh processName="$processName" 
# saving the id for future use
deployProcessId=$processId

source bin/createProcessAttachment.sh envId=$toEnvId processId=$processId componentType="process"

source bin/queryDeployment.sh processId=$deployProcessId envId=$fromEnvId version=$version current=$current

URL=$baseURL/deployProcess/${deploymentId}/${toEnvId}/$digest?listenerStatus=${listenerStatus}

curl -s -X POST -u $authToken -H "${h1}" -H "${h2}" $URL > out.json

clean

unset listenerStatus
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
