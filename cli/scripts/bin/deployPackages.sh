#!/bin/bash
source bin/common.sh

# mandatory arguments
ARGUMENTS=(env packageVersion notes listenerStatus) 
OPT_ARGUMENTS=(componentIds processNames extractComponentXmlFolder tag componentType)
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

saveNotes="${notes}"
savePackageVersion="${packageVersion}"
saveListenerStatus="${listenerStatus}"
saveComponentType="${componentType}"
saveTag="${tag}"
unset tag
if [ -z "${componentIds}" ]
then
	IFS=',' ;for processName in `echo "${processNames}"`; 
	do 
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    processName=`echo "${processName}" | xargs`
    saveProcessName="${processName}"
		listenerStatus="${saveListenerStatus}"
		componentType="${saveComponentType}"
		source bin/deployPackage.sh processName="${processName}" componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" env="${env}" listenerStatus="${listenerStatus}" extractComponentXmlFolder="${extractComponentXmlFolder}" tag=""
 	done   
else    
	IFS=',' ;for componentId in `echo "${componentIds}"`; 
	do 
		notes="${saveNotes}"
   	packageVersion="${savePackageVersion}"
    componentId=`echo "${componentId}" | xargs`
    saveComponentId="${componentId}"
		componentType="${saveComponentType}"
		listenerStatus="${saveListenerStatus}"
		source bin/deployPackage.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" env="${env}" listenerStatus="${listenerStatus}" extractComponentXmlFolder="${extractComponentXmlFolder}" tag=""
 	done   
fi  


# Tag all the packages of the release together
if [ ! -z "${extractComponentXmlFolder}" ] && [ null != "${extractComponentXmlFolder}" ] && [ "" != "${extractComponentXmlFolder}" ]
then
  folder="${WORKSPACE}/${extractComponentXmlFolder}"
	tag="${saveTag}"
  # Save componentExtractFolder into git
	if [ ! -z "${tag}" ] && [ null != "${tag}" ] && [ "" != "${tag}" ]
	then
    bin/gitrelease.sh baseFolder="${folder}" tag="${tag}" notes="${saveNotes}"
	fi
fi
			
clean
unset componentIds processNames

if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
