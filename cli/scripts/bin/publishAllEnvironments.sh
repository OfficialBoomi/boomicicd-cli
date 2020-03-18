#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
URL=$baseURL/Environment/query
JSON_FILE=json/queryEnvironmentAny.json
REPORT_TITLE="List of All Environments"
REPORT_HEADERS=("#" "Id" "Classification" "Name")
h=0
queryToken="new"

printReportHead

while [ null != "${queryToken}" ]
do
	callAPI
	if [ "$ERROR" -gt "0" ]
	then
  	break; 
	fi
	extractMap id ids
	extractMap name names
	extractMap classification classifications

	i=0

	while [ "$i" -lt "${#ids[@]}" ]
 	do 
  	printReportRow  "${h}" "${ids[$i]}" "${classifications[$i]}" "${names[$i]}"
  	i=$(( $i + 1 ))
  	h=$(( $h + 1 ))
 	done
  extract queryToken queryToken
	URL=$baseURL/Environment/queryMore
done

printReportTail
clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
