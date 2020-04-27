#!/bin/bash
source bin/common.sh

# No verbose for this script
saveVerbose=${VERBOSE}
unset VERBOSE

# mandatory arguments
ARGUMENTS=(packageIds)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

URL=$baseURL/PackagedComponentManifest
REPORT_TITLE="Packaged Components Manifest"
Environment Type	Environment Name	Component Name	Path	Sub Type	Component ID	Package ID	Environment ID	Counted?


REPORT_HEADERS=("#" "Env Name" "Env ID" "Env Type" "Package ID" "Component ID" "Component Name" "Component Type" "Sub Type" "Version" "Current" "Modified By" "Folder Name")
printReportHead

IFS=' '
h=0;
unset componentIds
unset componentVersions

for packageId in `echo "${packageIds}"`
do
	packageId=`echo $packageId | xargs`
	URL=$baseURL/PackagedComponentManifest/${packageId}
  getAPI	
  
  if [ "$ERROR" -gt "0" ]
	then
  	break; 
	fi
	
  k=0;

	extractComponentMap id cids
	extractComponentMap version cvs

	while [ "$k" -lt "${#cids[@]}" ]; 
	do 
		h=$(( $h + 1 ));
		componentId="${cids[$k]}"
		componentVersion="${cvs[$k]}"
		componentIds+=( "${componentId}" )
		componentVersions+=( "${componentVersion}" )
		source bin/getComponentMetadata.sh componentId="${componentId}" version="${componentVersion}"
    printReportRow  "${h}" "${packageId}" "${cids[$k]}" "${name}" "${type}" "${subType}" "${cvs[$k]}"	"${currentVersion}" "${modifiedBy}" "${folderName}"
		k=$(( $k + 1 )); 
	done
done

printReportTail
clean
export componentIds
export componentVersions
export VERBOSE=${saveVerbose}
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
