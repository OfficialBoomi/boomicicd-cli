#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
URL=$baseURL/Environment/query
JSON_FILE=json/queryEnvironmentAny.json
REPORT_TITLE="List of All Environments"
REPORT_HEADERS=("ID" "Classification" "Name")
callAPI

extractMap id ids
extractMap name names
extractMap classification classifications

printReportHead
i=0

while [ "$i" -lt "${#ids[@]}" ]
 do 
  printReportRow  "${ids[$i]}" "${classifications[$i]}" "${names[$i]}"
  i=$(( $i + 1 ))
 done

printReportTail
clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
