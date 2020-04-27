#!/bin/bash
set -e 
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
OPT_ARGUMENTS=(atomStatus atomType atomName atomId componentId processName)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

# Get componentId
if [ -z "${componentId}" ] 
then
	source bin/queryProcess.sh processName="${processName}"
fi

# Get atomId
if [ -z "${atomId}" ] 
then
	if [ -z "${atomStatus}" ] 
	then
		atomStatus="ONLINE"
	fi
	if [ -z "${atomType}" ] 
	then
		atomType="*"
	fi
	source bin/queryAtom.sh atomName="${atomName}" atomStatus="${atomType}" atomType="${atomType}"
fi	

if [ null != "${atomId}" ] 
then 
	source bin/queryAtomAttachment.sh atomId="${atomId}"
	if [ null != "${env}" ] && [ null != "${componentId}" ] 
	then
		source bin/queryDeployedComponent.sh componentId=${componentId} envId=${envId}
	fi
fi
		
if [ null != "${deploymentId}" ] 		
then 
	return 0
fi


clean

if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
