#!/bin/bash
source bin/common.sh

# mandatory arguments
ARGUMENTS=(packageVersion notes) 
OPT_ARGUMENTS=(componentIds processNames extractComponentXmlFolder tag componentType)
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

saveNotes="${notes}"
savePackageVersion="${packageVersion}"
saveComponentType="${componentType}"
packageIds=""
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
		componentType="${saveComponentType}"
		source bin/createPackage.sh processName="${processName}" componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" extractComponentXmlFolder="${extractComponentXmlFolder}" tag=""
 	done   
else    
	IFS=',' ;for componentId in `echo "${componentIds}"`; 
	do 
		notes="${saveNotes}"
   	packageVersion="${savePackageVersion}"
    componentId=`echo "${componentId}" | xargs`
    saveComponentId="${componentId}"
		componentType="${saveComponentType}"
		source bin/createPackage.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" extractComponentXmlFolder="${extractComponentXmlFolder}" tag=""
 	done   
fi  



# Tag all the packages of the release together
if [ ! -z "${extractComponentXmlFolder}" ] && [ null != "${extractComponentXmlFolder}}" ] && [ "" != "${extractComponentXmlFolder}" ]
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

if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
