#!/bin/bash
source bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env packageVersion notes listenerStatus)
OPT_ARGUMENTS=(componentId processName componentVersion extractComponentXmlFolder)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
deployNotes=$notes;

if [ -z "${componentId}" ]
then
	source bin/queryProcess.sh processName="$processName"
fi

source bin/createPackage.sh componentId=$componentId componentType="process" componentVersion="${componentVersion}" packageVersion="$packageVersion" notes="$notes" extractComponentXmlFolder="${extractComponentXmlFolder}"
source bin/queryEnvironment.sh env="$env" classification="*"
source bin/createDeployedPackage.sh envId=${envId} listenerStatus="${listenerStatus}" packageId=$packageId notes="$deployNotes"

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
