#!/bin/bash
source bin/common.sh

# No verbose for this script
saveVerbose=${VERBOSE}
unset VERBOSE

# mandatory arguments
ARGUMENTS=(packageVersion)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

URL=$baseURL/PackagedComponent/query
JSON_FILE=json/queryPackagedComponentVersion.json
REPORT_TITLE="List of Packaged Components"
REPORT_HEADERS=("#" "Component" "Package Version" "Component Type" "Created Date" "Created By" "Notes")
queryToken="new"
createJSON

h=0;

printReportHead
while [ null != "${queryToken}" ] 
do
	callAPI
	if [ "$ERROR" -gt "0" ]
	then
  	break; 
	fi
	i=0;
	extractMap deploymentId ids
	extractMap componentId cids
	extractMap packageVersion pvs
	extractMap componentType ctypes
	extractMap createdDate cdates
	extractMap createdBy cbys
	extractMap notes notes

	while [ "$i" -lt "${#ids[@]}" ]; 
	do 
		h=$(( $h + 1 ));
		URL=$baseURL/Process/${cids[$i]}
		name=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`
		
    printReportRow  "${h}" "${name}" "${pvs[$i]}" "${ctypes[$i]}" "${cdates[$i]}" "${cbys[$i]}" "${notes[$i]}"	
		i=$(( $i + 1 )); 
	done
  extract queryToken queryToken 	
	URL=$baseURL/Process/queryMore
done

printReportTail
clean
export VERBOSE=${saveVerbose}
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
