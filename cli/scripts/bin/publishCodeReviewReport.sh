#!/bin/bash

# Publish the code review report
saveVerbose="${VERBOSE}"
unset VERBOSE
source bin/common.sh
# FILE_ID is the unique ID where the GIT commit and components build details are stored
ARGUMENTS=(COMPONENT_LIST_FILE)
inputs "$@"

if [ -z "${gitComponentCommitPath}" ]
then
    gitComponentCommitPath="/tree/master/"
fi

REPORT_TITLE="Boomi Code Review Artifacts"
REPORT_HEADERS=("#" "Component ID" "Component Name")
# convert the 
httpRepoURL=$(echo ${gitComponentRepoURL} | sed -e  's/:/\//g' -e 's/^.*@/https:\/\//' -e 's/\.git//')
httpRepoURL="$httpRepoURL$gitComponentCommitPath"
printReportHead
mapfile -t <  <(cut -d '|' -f1 "${COMPONENT_LIST_FILE}") componentIds
mapfile -t <  <(cut -d '|' -f2 "${COMPONENT_LIST_FILE}") componentNames
mapfile -t <  <(cut -d '|' -f3 "${COMPONENT_LIST_FILE}") componentVersions
k=0 
h=0;
 while [ "$k" -lt "${#componentIds[@]}" ];
  do
   h=$(( $h + 1 ));
   componentId="${componentIds[$k]}"
	 componentVersion="${componentVersions[$k]}"
	 componentName="${componentNames[$k]}"
	
	 linkPlatform="<a href=\"https://platform.boomi.com/AtomSphere.html#build;accountId=${accountId};components=${componentId}~${componentVersion}\">${componentId}</a>"
	 linkGit="<a href=\"${httpRepoURL}${componentId}\">${componentName}</a>"
   printReportRow  "${h}" "${linkPlatform}" "${linkGit}" 
	 k=$(( $k + 1 ))
	done
printReportTail
export VERBOSE=${saveVerbose}
