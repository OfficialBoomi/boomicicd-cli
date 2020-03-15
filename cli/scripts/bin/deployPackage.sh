#!/bin/bash
source bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env packageVersion notes listenerStatus)
OPT_ARGUMENTS=(componentId processName)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
deployNotes=$notes;

if [ -z "${componentId" ]
then
	source bin/queryProcess.sh processName="$processName"
fi

source bin/createPackagedComponent.sh componentId=$componentId componentType="process" packageVersion=$packageVersion notes="$notes"
source bin/queryEnvironment.sh env="$env" classification="*"
source bin/createDeployedPackage.sh envId=${envId} listenerStatus="${listenerStatus}" packageId=$packageId notes="$deployNotes"

clean
