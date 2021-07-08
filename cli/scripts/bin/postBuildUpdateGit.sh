#!/bin/bash
# from common
function inputs {
     for ARGUMENT in "$@"
     do
       KEY=$(echo $ARGUMENT | cut -f1 -d=)
       VALUE="$(echo $ARGUMENT | cut -f2 -d=)"
        for i in "${ARGUMENTS[@]}"
        do
            # remove all old values of the ARGUMENTS
            case "$KEY" in
              $i)  unset ${KEY}; export eval $KEY="${VALUE}" ;;
              *)
                esac
        done
        
		for i in "${OPT_ARGUMENTS[@]}"
        do
            # remove all old values of the OPTIONAL ARGUMENTS
            case "$KEY" in
              $i)  unset ${KEY}; export eval $KEY="${VALUE}" ;;
              *)
                esac
        done

   done
 }
 
# unset all variables 
function clean {
   for i in "${ARGUMENTS[@]}"
   do
       unset $i
   done
   unset ARGUMENTS OPT_ARGUMENTS 
}

ARGUMENTS=(GIT_API_URL GIT_AUTH GIT_COMMIT JENKINS_CALLBACK_URL JOB_BASE_NAME STATE)
inputs "$@"
#GIT_API_URL=$1
#GIT_AUTH=$2
#GIT_COMMIT=$3
#JENKINS_CALLBACK_URL=$4
#JOB_BASE_NAME=$5
JOB_CONTEXT="${JOB_BASE_NAME// /_}"
BUILD_NUMBER=echo "${JENKINS_CALLBACK_URL}" | sed -E 's/^.*\/(.*)\/console/\1/'
#state=$6
if [ ! -z "${GIT_COMMIT}" ] && [ ! -z "${GIT_API_URL}" ]
 then
 echo "Updating status for commit=$GIT_COMMIT with context=${JOB_CONTEXT}"
 curl -u $GIT_AUTH ${GIT_API_URL}/statuses/$GIT_COMMIT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-X POST \
	-d "{\"state\": \"${STATE}\",\"context\": \"${JOB_CONTEXT}\", \"description\": \"Jenkins: ${JOB_CONTEXT}_${BUILD_NUMBER}\", \"target_url\": \"$JENKINS_CALLBACK_URL\"}"
	echo "GIT_API is ${GIT_API_URL}"
 fi

clean
