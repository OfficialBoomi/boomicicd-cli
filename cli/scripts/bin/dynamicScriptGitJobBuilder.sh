#!/bin/bash
# Sample code to recursively invoke Boomi scripts based on a configuration file 
source bin/common.sh
# Get the file name and the job envirnoment.

ARGUMENTS=(commit_id env conf_folder)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
GIT_COMMIT=commit_id

# This is the name of the stage or environment for this script. This is required to prevent a job in Development stage run in production
JOB_ENV="${env}"
unset env
cd "${conf_folder}"
for file in $(git diff --name-only --diff-filter=AM HEAD~1 $GIT_COMMIT | grep .conf)
do
 fileName=$(echo "${file}" | sed -e 's/^.*\///g' -e 's/\.conf.*$//g')
 echoi "Executing configurations for file ${file}." 
 count=1
 for row in $(cat "${file}" | jq -r '.pipelines[] | @base64');
  do
   PROP_FILE="/tmp/${fileName}_${count}.sh"
   rm -rf "${PROP_FILE}"
   json=$(echo ${row} | base64 --decode | jq -r 'to_entries' | \
     jq --arg count "$count" '. + [{"key": "count", "value": $count}]' | \
     jq --arg GIT_COMMIT "$GIT_COMMIT" '. + [{"key": "GIT_COMMIT", "value": $GIT_COMMIT}]')
   	 echo "${json}" | jq -r 'map("export \(.key)=\(.value|tostring|@sh)") | .[]' > "${PROP_FILE}"
    

     # This check ensure that jobs are triggered for only the allowed env.
     # This will prevent a development job to trigger builds in production.
     # If env is null use the JOB ENV as the env
	 job=$(echo $json | jq -r '.[] |  select(.key | contains("job")).value')
     env=$(echo $json | jq -r '.[] |  select(.key | contains("env")).value')
	
     # This check ensure that jobs are triggered for only the allowed env.
     # This will prevent a development job to trigger builds in production.
     # If env is null use the JOB ENV as the env
     if [ -z "${env}"  ]
     then
          env="${JOB_ENV}"
          json=$(echo ${json} | jq --arg env "$env" '. + [{"key": "env", "value": $env}]')           
     fi

	 if [ ${env} == "${JOB_ENV}" ]
     then
 		 call_script "${job}" "${json}"
     else
       echo "Ignoring job ${job} for env ${env} as it does not match the JOB_ENV ${JOB_ENV}."
     fi
   count=$(( count + 1 ))
 done
done
