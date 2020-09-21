#!/bin/bash

source bin/common.sh
source bin/regression.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(testSuiteExecutionId)
OPT_ARGUMENTS=(failOnError minTestCoverage componentId processName)
MAX_COUNT=20
WAIT=30
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

if [ -z "${failOnError}" ]
then
    failOnError="false"
fi

if [ -z "${minTestCoverage}" ]
then
    minTestCoverage="-1"
fi


if [ -z "${componentId}" ]
then
  source bin/queryProcess.sh processName="$processName"
fi
processId=${componentId}

URL="$regressionTestURL/getGetTestSuiteExecutionDetails?processId=${processId}&testSuiteExecutionId=${testSuiteExecutionId}"
echov "Extract test results from ${URL}."
count=0


while [ $count -lt "${MAX_COUNT}" ]
do
	sleep ${WAIT}
	getTestAPI
  extract [0].status status
	echov "Status is ${status}. Count is $count."
	if [ "${status}" = "COMPLETED" ]
  then
		count="${MAX_COUNT}"
	fi 
  extract [0].result result
  extract [0].testSuiteTestCoverage testSuiteTestCoverage
	count=$(( $count + 1 ))
done

clean

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

if [ "$failOnError" == "true" ]
then
	if [ "$result" != "OK" ]
    then
			 export ERROR_MESSAGE="Process failed with with STATUS = ${result}."
			 echo -e ${ERROR_MESSAGE}
    	 return 255 
    fi
fi


if [ ! -z "$minTestCoverage" ]
then
	if [ "$testSuiteTestCoverage" -lt "${minTestCoverage}" ]
    then
			 export ERROR_MESSAGE="Regression suite test coverage ${testSuiteTestCoverage} is not sufficient."
			 echo -e ${ERROR_MESSAGE}
    	 return 255 
    fi
fi
