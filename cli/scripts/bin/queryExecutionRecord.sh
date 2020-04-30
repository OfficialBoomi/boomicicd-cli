#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(from to atomName)
OPT_ARGUMENTS=(processName componentId failOnError)
JSON_FILE=json/queryExecutionRecord.json
URL=$baseURL/ExecutionRecord/query
id=result[0].executionId
exportVariable=executionId
now=`date -u +"%Y-%m-%d"T%H:%M:%SZ --date '+1 min'`
lag=`date -u +"%Y-%m-%d"T%H:%M:%SZ --date '-3 min'`
if [ -z "${to}" ]
then
       to=$now
fi

if [ -z "${from}" ]
then
       from=$lag
fi

if [ -z "${processName}" ]
then
       processName="%%"
fi

if [ -z "${componentId}" ]
then
      componentId="%%"
fi

inputs "$@"


if [ "$?" -gt "0" ]
then
        return 255;
fi

if [ -z "${failOnError}" ]
then
    failOnError="false"
fi

processId=${componentId}

ARGUMENTS=(from to processName atomName processId)
createJSON
 
callAPI

extract result[0].status status
extract result[0].message message
 
clean

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

if [ "$failOnError" == "true" ]
then
	if [ "$status" != "COMPLETE" ]
    then
			 export ERROR_MESSAGE="Process failed with with STATUS = ${status}."
			 echo -e ${ERROR_MESSAGE}
    	 exit 255 
    fi
fi
