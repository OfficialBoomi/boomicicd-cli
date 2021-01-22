#!/bin/bash

##########################################################################
# This script prints the process in the account and the full folder path #
##########################################################################

source bin/common.sh
# No verbose of this script. 
saveVerbose=${VERBOSE}
unset VERBOSE

# mandatory arguments
ARGUMENTS=(processName)
JSON_FILE=json/searchProcess.json
URL=$baseURL/Process/query
append="%"
REPORT_TITLE="List of Processes"
REPORT_HEADERS=("#" "Process Id" "Process Name", "Folder Path")
queryToken="new"
inputs "$@"

if [ "$?" -gt "0" ]
then
        return 255;
fi

processName="${append}${processName}${append}"
createJSON

printReportHead

hh=0;
while [ null != "${queryToken}" ] 
do
	callAPI
	if [ "$ERROR" -gt "0" ]
	then
  	break;
	fi
	ii=0;
  extractMap id ids	
  extractMap name names	
  extract queryToken queryToken 
	while [ "$ii" -lt "${#ids[@]}" ];
	 do 
		hh=$(( $hh + 1 ))
		source bin/getComponentMetadata.sh componentId=${ids[$ii]}
		source bin/getFolder.sh folderId=${folderId}
		printReportRow  "${hh}" "${ids[$ii]}" "${names[$ii]}" "${fullPath}" 
		ii=$(( $ii + 1 )); 
    done
	URL=$baseURL/Process/queryMore
done

printReportTail
clean
export VERBOSE=${saveVerbose}

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
