#!/bin/bash
# Sample code to invoke JENKINS PIPELINE via curl

set -e
JENKINS_USER=
JENKINS_TOKEN=
JENKINS_URL=
JOB_URL=${JENKINS_URL}/job/Account_%7BRename%7D/job
CRUMBS=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,':',//crumb)")

function call_job {
	local JOB=${1}
  local json=${2}
	ENCODED_JOB=$(echo $JOB | sed -e 's/ /\%20/g')
  JOB_URL="${JENKINS_URL}/job/Account_%7BRename%7D/job/${ENCODED_JOB}/buildWithParameters"
	unset PARAMS
  for row in $(echo "${json}" | jq -r '.[] | @base64');
	do
		json=$(echo "${row}" | base64 --decode)
		key=$(echo "${json}" |  jq -r '.key')
		value=$(echo "${json}" | jq -r '.value')
		if [ "job" != "$key" ] || [ "count" != "$key" ]
		then
			PARAMS+="--data-urlencode '$key=$value'"
		  PARAMS+=" "
		fi
  done
  curlString=$(echo "curl -X POST -u \"$JENKINS_USER:$JENKINS_TOKEN\" -H \"${CRUMBS}\" ${PARAMS} ${JOB_URL}")
  eval ${curlString}
}


file="${1}"
fileName=$(echo "${file}" | sed -e 's/^.*\///g' -e 's/\.conf.*$//g')
# Searching for text in the comments in the form #JIRA:PRO-1234
count=1
for row in $(cat "${file}" | jq -r '.pipelines[] | @base64');
do
	 	PROP_FILE="/tmp/${fileName}_${count}.sh"
	 	rm -rf "${PROP_FILE}"
    json=$(echo ${row} | base64 --decode | jq -r 'to_entries' | jq --arg count "$count" '. + [{"key": "count", "value": $count}]') 
    echo "${json}" | jq -r 'map("export \(.key)=\(.value|tostring|@sh)") | .[]' > "${PROP_FILE}"
	 	if [ -s $PROP_FILE ]
	 	then 
	 			chmod +x ${PROP_FILE}
				source ${PROP_FILE}
  		  call_job "${job}" "${json}" 
	 	fi	
		count=$(( count + 1 ))
done
