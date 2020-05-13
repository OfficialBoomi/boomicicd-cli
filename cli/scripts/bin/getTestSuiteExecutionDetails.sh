#!/bin/bash

source bin/common.sh
source bin/regression.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(testSuiteExecutionId)
OPT_ARGUMENTS=(failOnError minTestCoverage componentId processName)

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


while [ $count -lt 6 ]
do
	sleep 30
	getTestAPI
  extract status status
	echov "Status is ${status}. Count is $count."
	if [ "${status}" = "COMPLETED" ]
  then
		count=6
	fi 
  extract result result
  extract testSuiteTestCoverage testSuiteTestCoverage
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
