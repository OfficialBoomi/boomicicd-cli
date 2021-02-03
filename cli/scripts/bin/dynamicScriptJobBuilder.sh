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
count=1
 for row in $(cat "${file}" | jq -r '.pipelines[] | @base64');
  do
   PROP_FILE="/tmp/${fileName}_${count}.sh"
   rm -rf "${PROP_FILE}"
   json=$(echo ${row} | base64 --decode | jq -r 'to_entries' | \
     jq --arg count "$count" '. + [{"key": "count", "value": $count}]' 
   echo "${json}" | jq -r 'map("export \(.key)=\(.value|tostring|@sh)") | .[]' > "${PROP_FILE}"
    
	if [ -s $PROP_FILE ]
    then
     chmod +x ${PROP_FILE}
     source ${PROP_FILE}

     # This check ensure that jobs are triggered for only the allowed env.
     # This will prevent a development job to trigger builds in production.
     if [ ${env} == "${JOB_ENV}" ]
     then
 		 call_script "${job}" "${json}"
     else
       echo "Ignoring job ${job} for env ${env} as it does not match the JOB_ENV ${JOB_ENV}."
     fi
    fi
   count=$(( count + 1 ))
 done
