#!/bin/bash
# Sample code to invoke JENKINS PIPELINE via curl

set -e
# JOB_URL will be set if only the JENKINS_URL is set in the envirnoment. 
if [ ! -z "${JOB_URL}" ]
then
	echo "Job URL is ${JOB_URL}"
	JENKINS_URL=$(echo "${JOB_URL}" | sed -E 's/\/job.*$//')
	JOB_URL_BASE=$(echo "${JOB_URL}" | sed -E 's/(.*)job.*$/\1/')
fi 

CRUMBS=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,':',//crumb)")

#echo "Jenkins CRUMBS is ${CRUMBS}"
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

# Main.
for file in $(git diff --name-only --diff-filter=AM HEAD~1 $GIT_COMMIT | grep .conf)
do
 fileName=$(echo "${file}" | sed -e 's/^.*\///g' -e 's/\.conf.*$//g')
 # Searching for text in the comments in the form #JIRA:PRO-1234
 count=1
 for row in $(cat "${file}" | jq -r '.pipelines[] | @base64');
 do
    json=$(echo ${row} | base64 --decode | jq -r 'to_entries' | \
      	jq --arg count "$count" '. + [{"key": "count", "value": $count}]' | \
     	jq --arg GIT_COMMIT "$GIT_COMMIT" '. + [{"key": "GIT_COMMIT", "value": $GIT_COMMIT}]')
 	job=$(echo $json | jq -r '.[] |  select(.key | contains("job")).value')	
	env=$(echo $json | jq -r '.[] |  select(.key | contains("env")).value')
	if [ -z "${env}"  ]
	then
		env="${JOB_ENV}"
		json=$(echo ${json} | jq --arg env "$env" '. + [{"key": "env", "value": $env}]')
	fi	
	# This check ensure that jobs are triggered for only the allowed env. 
	# This will prevent a development job to trigger builds in production.
	if [ ${env} == "${JOB_ENV}" ]
	then
     call_job "${job}" "${json}" 
	else
	 echo "Ignoring job ${job} for env ${env} as it does not match the JOB_ENV ${JOB_ENV}."
	fi
	count=$(( count + 1 ))
 done
done
