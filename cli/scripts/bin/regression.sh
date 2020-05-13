#!/bin/bash
# call platform API
function callTestAPI {
	unset ERROR ERROR_MESSAGE
	if [ ! -z ${SLEEP_TIMER} ]; then sleep ${SLEEP_TIMER}; fi
  if [[ $URL != *queryMore* ]]
  then
   curl -s -X POST -u $regressionTestAuthToken -H "${h1}" -H "${h2}" $URL -d@"${WORKSPACE}"/tmp.json > "${WORKSPACE}"/out.json
   export ERROR=`jq  -r . "${WORKSPACE}"/out.json  |  grep '"@type": "Error"' | wc -l`
   if [[ $ERROR -gt 0 ]]; then 
	   export ERROR_MESSAGE=`jq -r .message "${WORKSPACE}"/out.json` 
		 echo $ERROR_MESSAGE 
	  return 251
   fi
 
   if [ ! -z "$exportVariable" ]
   then
  	 export ${exportVariable}=`jq -r .$id "${WORKSPACE}"/out.json`
		 echovv "export ${exportVariable}=${!exportVariable}."
   fi
  else
   curl -s -X POST -u $regressionTestAuthToken -H "${h1}" -H "${h2}" $URL -d${queryToken} > "${WORKSPACE}"/out.json
   export ERROR=`jq  -r . "${WORKSPACE}"/out.json  |  grep '"@type": "Error"' | wc -l`
   if [[ $ERROR -gt 0 ]]; then 
	  export ERROR_MESSAGE=`jq -r .message "${WORKSPACE}"/out.json` 
		echo $ERROR_MESSAGE 
	 return 251
   fi
 fi
 if [ "$VERBOSE" == "true" ]  
 then 
  cat  "${WORKSPACE}"/out.json >> "${WORKSPACE}"/outs.json
  cat  "${WORKSPACE}"/tmp.json >> "${WORKSPACE}"/tmps.json
 fi
}

function getTestAPI {
	unset ERROR ERROR_MESSAGE
	if [ ! -z ${SLEEP_TIMER} ]; then sleep ${SLEEP_TIMER}; fi
  curl -s -X GET -u $regressionTestAuthToken -H "${h1}" -H "${h2}" "$URL" > "${WORKSPACE}"/out.json
  export ERROR=`jq  -r . "${WORKSPACE}"/out.json  |  grep '"@type": "Error"' | wc -l`
  if [[ $ERROR -gt 0 ]]; then 
	  export ERROR_MESSAGE=`jq -r .message "${WORKSPACE}"/out.json` 
		echo $ERROR_MESSAGE 
	 return 251
  fi
  if [ "$VERBOSE" == "true" ]  
  then 
   cat  "${WORKSPACE}"/out.json >> "${WORKSPACE}"/outs.json
  fi
}

