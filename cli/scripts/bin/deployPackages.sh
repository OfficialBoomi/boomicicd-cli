#!/bin/bash
source bin/common.sh

# mandatory arguments
ARGUMENTS=(env componentType packageVersion notes listenerStatus) 
OPT_ARGUMENTS=(componentIds processNames extractComponentXmlFolder)
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

saveNotes="${notes}"
savePackageVersion="${packageVersion}"
saveListenerStatus="${listenerStatus}"
if [ -z "${componentIds}" ]
then
	IFS=',' ;for processName in `echo "${processNames}"`; 
	do 
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    processName=`echo "${processName}" | xargs`
    saveProcessName="${processName}"
		listenerStatus="${saveListenerStatus}"
		source bin/deployPackage.sh processName="${processName}" componentType="Process" packageVersion="${packageVersion}" notes="${notes}" env="${env}" listenerStatus="${listenerStatus}" extractComponentXmlFolder="${extractComponentXmlFolder}"
 	done   
else    
	IFS=',' ;for componentId in `echo "${componentIds}"`; 
	do 
		notes="${saveNotes}"
   	packageVersion="${savePackageVersion}"
    componentId=`echo "${componentId}" | xargs`
    saveComponentId="${componentId}"
		listenerStatus="${saveListenerStatus}"
		source bin/deployPackage.sh componentId=${componentId} componentType="Process" packageVersion="${packageVersion}" notes="${notes}" env="${env}" listenerStatus="${listenerStatus}" extractComponentXmlFolder="${extractComponentXmlFolder}"
 	done   
fi  

clean
unset componentIds processNames

if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
