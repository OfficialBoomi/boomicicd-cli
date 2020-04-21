#!/bin/bash
source bin/common.sh

# mandatory arguments
ARGUMENTS=(componentType packageVersion notes) 
OPT_ARGUMENTS=(componentId processName extractComponentXmlFolder componentVersion)
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi
folder="${extractComponentXmlFolder}"
saveNotes="${notes}"
savePackageVersion="${packageVersion}"
if [ -z "${componentId}" ]
then
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    processName=`echo "${processName}" | xargs`
    saveProcessName="${processName}"
		source bin/queryProcess.sh processName="${processName}"
		source bin/createPackagedComponent.sh componentId=${componentId} componentType="Process" packageVersion="${packageVersion}" notes="${notes}" componentVersion=${componentVersion}
		echo "Created package ${packageId} for process ${saveProcessName}"
else    
		notes="${saveNotes}"
    packageVersion="${savePackageVersion}"
    componentId=`echo "${componentId}" | xargs`
    saveComponentId="${componentId}"
		source bin/createPackagedComponent.sh componentId=${componentId} componentType="Process" packageVersion="${packageVersion}" notes="${notes}" componentVersion=${componentVersion}
		echo "Created package ${packageId} for componentId ${saveComponentId}"
fi  

if [ ! -z "${folder}" ] && [ null != "${folder}" ] && [ "" != ${folder} ]
then
	packageFolder="${WORKSPACE}/${folder}/${packageId}"
	mkdir -p "${packageFolder}"
	savePackageId=${packageId}
	source bin/publishPackagedComponentMetadata.sh packageIds="${packageId}" > "${packageFolder}"/package.html
  g=0
	for g in ${!componentIds[@]}; 
	do
		componentId=${componentIds[$g]}
		componentVersion=${componentVersions[$g]}
		#echo "Extracting component xml for ${componentId} and ${componentVersion}." 
		source bin/getComponent.sh componentId=${componentId} version=${componentVersion}  
    mv "${WORKSPACE}"/${componentIds[$g]}_*.xml "${packageFolder}"
	done	
fi

clean
unset folder packageFolder
export packageId=${savePackageId}


if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
