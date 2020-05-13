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
saveComponentType="${componentType}"
if [ -z "${componentId}" ] || [ null == "${componentId}" ]
then
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    processName=`echo "${processName}" | xargs`
    saveProcessName="${processName}"
    componentType="${saveComponentType}"
    componentId=""
		source bin/queryComponentMetadata.sh componentName="${processName}" componentType="${componentType}" componentId="${componentId}"
    saveComponentId="${componentId}"
		echo "source bin/createPackagedComponent.sh componentId=${componentId} componentType=${componentType} packageVersion=${packageVersion} notes=${notes} componentVersion=${componentVersion}"
		source bin/createPackagedComponent.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion="${componentVersion}"
		echov "Created package ${packageId} for process ${saveProcessName}"
else    
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    componentId=`echo "${componentId}" | xargs`
    saveComponentId="${componentId}"
    componentType="${saveComponentType}"
		processName=""
		source bin/queryComponentMetadata.sh componentName="${processName}" componentType="${componentType}" componentId="${componentId}"
		source bin/createPackagedComponent.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion="${componentVersion}"
		echov "Created package ${packageId} for componentId ${saveComponentId}"
fi  

savePackageId=${packageId}
# Extract Boomi componentXMLs to a local disk
if [ ! -z "${extractComponentXmlFolder}" ] && [ null != "${extractComponentXmlFolder}" ] && [ "" != "${extractComponentXmlFolder}" ]
then
  folder="${WORKSPACE}/${extractComponentXmlFolder}"
	packageFolder="${folder}/${saveComponentId}"
	mkdir -p "${packageFolder}"
	echov "Publishing package metatdata for ${packageId}."
	source bin/publishPackagedComponentMetadata.sh packageIds="${packageId}" > "${packageFolder}/${packageId}_${savePackageVersion}.html"
  g=0
	for g in ${!componentIds[@]}; 
	do
		componentId=${componentIds[$g]}
		componentVersion=${componentVersions[$g]}
		source bin/getComponent.sh componentId=${componentId} version=${componentVersion} 
    eval `cat "${WORKSPACE}"/${componentIds[$g]}*.xml | xmllint --xpath '//*/@folderFullPath' -`
    mkdir -p "${packageFolder}/${folderFullPath}" 
    mv "${WORKSPACE}"/${componentIds[$g]}*.xml "${packageFolder}/${folderFullPath}" 
	done
  # Create a violations report using sonarqube rules	
	bin/xpathRulesChecker.sh baseFolder="${packageFolder}" > "${packageFolder}/${saveComponentId}_violationsReport.html"
  # Save componentExtractFolder into git
  if [ ! -z "${tag}" ] && [ null != "${tag}" ] && [ "" != "${tag}" ]
  then
	  bin/sonarScanner.sh baseFolder="${folder}"
	  bin/gitPush.sh baseFolder="${folder}" tag="${tag}" notes="${saveNotes}"
  fi

fi

clean
unset folder packageFolder
export packageId=${savePackageId}


if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
