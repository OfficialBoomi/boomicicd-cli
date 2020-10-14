#!/bin/bash
# Sample code to invoke JENKINS PIPELINE via curl

set -e
JENKINS_URL=$(echo "${JOB_URL}" | sed -E 's/\/job.*$//')
JOB_URL_BASE=$(echo "${JOB_URL}" | sed -E 's/(.*)job.*$/\1/')
CRUMBS=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,':',//crumb)")

function call_job {
	local JOB=${1}
  local json=${2}
  
  #	Remove spaces in the job name
	ENCODED_JOB=$(echo $JOB | sed -e 's/ /\%20/g')
  JOB_URL="${JOB_URL_BASE}/job/${ENCODED_JOB}/buildWithParameters"
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


for file in $(git diff --name-only --diff-filter=AM HEAD~1 $BUILDKITE_COMMIT | grep .conf)
do
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
				# This check ensure that jobs are triggered for only the allowed env. 
				# This will prevent a development job to trigger builds in production.
				if [ ${env} == "${JOB_ENV}" ]
				then
  		  	call_job "${job}" "${json}" 
			  fi
	 	fi	
		count=$(( count + 1 ))
 done
done
