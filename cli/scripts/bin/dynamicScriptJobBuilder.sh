#!/bin/bash
# Sample code to recursively invoke Boomi scripts based on a configuration file 
source bin/common.sh
# Get the file name and the job envirnoment.

ARGUMENTS=(file env)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi


# This is the name of the stage or environment for this script. This is required to prevent a job in Development stage run in production
JOB_ENV="${env}"
unset env

fileName=$(echo "${file}" | sed -e 's/^.*\///g' -e 's/\.conf.*$//g')
echoi "Executing configurations for file ${file}."
notes="${BUILD_PROJECTNAME}_${RELEASE_RELEASENAME}_${BUILD_BUILDNUMBER}: ${notes}"
count=1
 for row in $(cat "${file}" | jq -r '.pipelines[] | @base64');
  do
   
   json=$(echo ${row} | base64 --decode | jq -r 'to_entries' | \
     jq --arg count "$count" '. + [{"key": "count", "value": $count}]') 
   
     job=$(echo $json | jq -r '.[] |  select(.key | contains("job")).value')
     env=$(echo $json | jq -r '.[] |  select(.key | contains("env")).value')
	 
	 # Automatically tag azure build info in Boomi deployment notes 
	 if [[ ! -z "${BUILD_BUILDNUMBER}" ]]
	 then
	 	notes=$(echo $json | jq -r '.[] |  select(.key | contains("notes")).value')
     	notes="${BUILD_PROJECTNAME}_${RELEASE_RELEASENAME}_${BUILD_BUILDNUMBER}: ${notes}"
     	json=$(echo ${json} | jq --arg notes "$notes" '. + [{"key": "notes", "value": $notes}]')
	 fi

     # This check ensure that jobs are triggered for only the allowed env.
     # This will prevent a development job to trigger builds in production.
     # If env is null use the JOB ENV as the env
     if [ -z "${env}"  ]
     then
          env="${JOB_ENV}"
          json=$(echo ${json} | jq --arg env "$env" '. + [{"key": "env", "value": $env}]')
                    
     fi
     if [ "${env}" == "${JOB_ENV}" ]
     then
 		   call_script "${job}" "${json}"
     else
       echo "Ignoring job ${job} for env ${env} as it does not match the JOB_ENV ${JOB_ENV}."
     fi
  
   count=$(( count + 1 ))
 done
