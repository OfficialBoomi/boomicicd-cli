#!/bin/bash
source bin/common.sh

# No verbose for this script
saveVerbose=${VERBOSE}
unset VERBOSE

# mandatory arguments
ARGUMENTS=(env)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
source bin/queryEnvironment.sh env="${env}" classification="*"

ARGUMENTS=(envId)
URL=$baseURL/DeployedPackage/query
JSON_FILE=json/queryDeployedPackageEnv.json
REPORT_TILE="List of Deployed Packages"
REPORT_HEADERS=("#" "Component" "Package Version" "Environment" "Component Type" "Deployed Date" "Deployed By" "Notes")
queryToken="new"
createJSON

h=0;

printReportHead

while [ null != "${queryToken}" ] 
do
	i=0;
	callAPI
	if [ "$ERROR" -gt "0" ]
	then
   break
	fi
	extractMap deploymentId ids 
	extractMap componentId cids 
	extractMap packageVersion pvs 
	extractMap environmentId eids 
	extractMap componentType ctypes 
	extractMap deployedDates ddates 
	extractMap deployedBy dbys 
	extractMap notes notes 

	while [ "$i" -lt "${#ids[@]}" ]; 
	do 
		h=$(( $h + 1 ));
		URL=$baseURL/Process/${cids[$i]}
		name=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`
		
		URL=$baseURL/Environment/${eids[$i]}
		env=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`

    printReportRow  "${h}" "${name}" "${pvs[$i]}" "${env}" "${ctypes[$i]}" "${ddates[$i]}" "${dbys[$i]}" "${notes[$i]}"	
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
