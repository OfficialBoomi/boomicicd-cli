#!/bin/bash
source bin/common.sh

# mandatory arguments
ARGUMENTS=(packageVersion notes) 
OPT_ARGUMENTS=(componentId processName extractComponentXmlFolder componentVersion tag componentType)
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi
folder="${WORKSPACE}/${extractComponentXmlFolder}"
saveNotes="${notes}"
savePackageVersion="${packageVersion}"

# Save componentExtractFolder into git
if [ -z "${componentType}" ] || [ null == "${componentType}" ] || [ "" == "${componentType}" ]
 then
	componentType="Process"
fi
#printArgs
if [ -z "${componentId}" ]
then
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    processName=`echo "${processName}" | xargs`
    saveProcessName="${processName}"
		source bin/queryProcess.sh processName="${processName}"
		source bin/createPackagedComponent.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion=${componentVersion}
		echov "Created package ${packageId} for process ${saveProcessName}"
else    
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    componentId=`echo "${componentId}" | xargs`
    saveComponentId="${componentId}"
		source bin/createPackagedComponent.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion=${componentVersion}
		echov "Created package ${packageId} for componentId ${saveComponentId}"
fi  

savePackageId=${packageId}

# Extract Boomi componentXMLs to a local disk
if [ ! -z "${extractComponentXmlFolder}" ] && [ null != "${extractComponentXmlFolder}" ] && [ "" != "${extractComponentXmlFolder}" ]
then
  folder="${WORKSPACE}/${extractComponentXmlFolder}"
	packageFolder="${folder}/${packageId}"
	mkdir -p "${packageFolder}"
	echov "Publishing package metatdata for ${packageId}."
	source bin/publishPackagedComponentMetadata.sh packageIds="${packageId}" > "${packageFolder}"/package.html
  g=0
	for g in ${!componentIds[@]}; 
	do
		componentId=${componentIds[$g]}
		componentVersion=${componentVersions[$g]}
		source bin/getComponent.sh componentId=${componentId} version=${componentVersion}  
    mv "${WORKSPACE}"/${componentIds[$g]}_*.xml "${packageFolder}"
	done	
  # Save componentExtractFolder into git
  if [ ! -z "${tag}" ] && [ null != "${tag}" ] && [ "" != "${tag}" ]
  then
	  bin/gitrelease.sh baseFolder="${folder}" tag="${tag}" notes="${saveNotes}"
  fi

fi

clean
unset folder packageFolder
export packageId=${savePackageId}


if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
