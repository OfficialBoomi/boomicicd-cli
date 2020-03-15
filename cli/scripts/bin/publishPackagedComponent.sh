#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
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
REPORT_HEADERS=("#" "Component" "Package Version" "Component Type" "Deployed Date" "Deployed By" "Notes")
queryToken="new"
createJSON

h=0;

printReportHead
while [ null != "${queryToken}" ] 
do
	callAPI
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
	queryToken=`jq -r .queryToken "$WORKSPACE/out.json"`
	URL=$baseURL/Process/queryMore
done

printReportTail
clean
