#!/bin/bash
source bin/common.sh

# mandatory arguments
ARGUMENTS=(componentType packageVersion notes) 
OPT_ARGUMENTS=(componentIds processNames extractComponentXmlFolder)
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

saveNotes="${notes}"
savePackageVersion="${packageVersion}"
packageIds=""
if [ -z "${componentIds}" ]
then
	IFS=',' ;for processName in `echo "${processNames}"`; 
	do 
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    processName=`echo "${processName}" | xargs`
    saveProcessName="${processName}"
		source bin/createPackage.sh processName="${processName}" componentType="Process" packageVersion="${packageVersion}" notes="${notes}" extractComponentXmlFolder="${extractComponentXmlFolder}"
 	done   
else    
	IFS=',' ;for componentId in `echo "${componentIds}"`; 
	do 
		notes="${saveNotes}"
   	packageVersion="${savePackageVersion}"
    componentId=`echo "${componentId}" | xargs`
    saveComponentId="${componentId}"
		source bin/createPackage.sh componentId=${componentId} componentType="Process" packageVersion="${packageVersion}" notes="${notes}" extractComponentXmlFolder="${extractComponentXmlFolder}" 
 	done   
fi  

clean

if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
