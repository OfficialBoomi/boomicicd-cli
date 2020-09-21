#!/bin/bash
# Publish a list of atoms
source bin/common.sh
saveVerbose=${VERBOSE}
unset VERBOSE
JSON_FILE=json/queryAny.json
URL=$baseURL/Atom/query
REPORT_TITLE="List of Atoms"
REPORT_HEADERS=("#" "Atom Id" "Atom Name" "Env Name" "Status")
queryToken="new"


createJSON
 
printReportHead

h=0

while [ null != "${queryToken}" ]
do
		callAPI
		if [ "$ERROR" -gt "0" ]
		then
   		break;
		fi
		extractMap id ids
		extractMap name names
		extractMap status statuss
		
		k=0
		while [ "$k" -lt "${#ids[@]}" ];
		do
				h=$(( $h + 1 ));
				atomId=${ids[$k]}
				source bin/queryAtomAttachment.sh atomId="${atomId}" envId="%%"
				env=""
				if [ null != "${envId}" ]
				then
					URL=$baseURL/Environment/${envId}
					env=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`
				fi
				printReportRow "${h}" "${atomId}" "${names[$k]}" "${env}" "${statuss[$k]}"	
				#printf  "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n"  "<tr><th>${h}</th>" "<th>${atomId}</th>" "<th>${names[$k]}</th>" "<th>${env}</th>" "<th>${statuss[$k]}</th></tr>";
				k=$(( $k + 1 ));
		done
				
		URL=$baseURL/Process/queryMore
		extract queryToken queryToken
done

printReportTail
 
clean
export VERBOSE=${saveVerbose}
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
