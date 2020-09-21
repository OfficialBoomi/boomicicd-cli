#!/bin/bash
unset ARGUMENTS OPT_ARGUMENTS
# Capture user inputs
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
 
   			if [ $KEY = "help" ]
   				then
    	 			usage
     			return 255; 
   			fi
   done
 
   # Check inputs
   for i in "${ARGUMENTS[@]}"
   do
    if [ -z "${!i}" ]
    then
      echo "Missing mandatory field:  ${i}"
      usage
      return 255;
    fi
   done

	if [ "${VERBOSE}" == "true" ]
	then
		echo "Executing script: ${BASH_SOURCE[1]} with arguments"
		echo "----"
		printArgs
		echo "----"
	fi
  }
 
# The help function
function usage {
   #echo "Usage"
    var=""
    for ARGUMENT in "${ARGUMENTS[@]}"
    do
     var=$var"${ARGUMENT}=\${$ARGUMENT} "
    done
		
    for ARGUMENT in "${OPT_ARGUMENTS[@]}"
    do
     var="$var[${ARGUMENT}=\${$ARGUMENT}] "
    done
   echo "source ${BASH_SOURCE[2]} $var"
}
 
# The help function
function printArgs {
    for ARGUMENT in "${ARGUMENTS[@]}"
    do
     echo "${ARGUMENT}=${!ARGUMENT}"
    done

    for ARGUMENT in "${OPT_ARGUMENTS[@]}"
    do
     echo "(${ARGUMENT}=${!ARGUMENT})"
    done
}


# Create JSON file with inputs from template
function createJSON {
	# Iteratively create a query string to replace the variables in the JSON File
  if [ null == "${ARGUMENTS}"	] || [ -z "${ARGUMENTS}" ]
	then 
		cp $JSON_FILE "${WORKSPACE}"/tmp.json
  else
 		var="sed "
 		for i in "${ARGUMENTS[@]}"
  		do var=$var" -e \"s/\\\${${i}}/${!i}/\" ";
 		done
 		var=$var" $JSON_FILE > \"${WORKSPACE}\"/tmp.json"
 		eval $var
	fi
}

# unset all variables and tmp files
function clean {
	 for i in "${ARGUMENTS[@]}"
		do
			unset $i
	  done
	 unset JSON_FILE ARGUMENTS id URL var ARGUMENT i exportVariable reportHeaders reportTitle OPT_ARGUMENTS IFS
	 #rm -f "${WORKSPACE}"/*.json
}

# call platform API
function callAPI {
	unset ERROR ERROR_MESSAGE
	if [ ! -z ${SLEEP_TIMER} ]; then sleep ${SLEEP_TIMER}; fi
  if [[ $URL != *queryMore* ]]
  then
   curl -s -X POST -u $authToken -H "${h1}" -H "${h2}" $URL -d@"${WORKSPACE}"/tmp.json > "${WORKSPACE}"/out.json
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
   curl -s -X POST -u $authToken -H "${h1}" -H "${h2}" $URL -d${queryToken} > "${WORKSPACE}"/out.json
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

function getAPI {
	unset ERROR ERROR_MESSAGE
	if [ ! -z ${SLEEP_TIMER} ]; then sleep ${SLEEP_TIMER}; fi
  curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" "$URL" > "${WORKSPACE}"/out.json
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

function getXMLAPI {
	unset ERROR ERROR_MESSAGE
	export ERROR=0
  export ERROR_MESSAGE=""
	if [ ! -z ${SLEEP_TIMER} ]; then sleep ${SLEEP_TIMER}; fi
  curl -s -X GET -u $authToken -H "application/xml" -H "application/xml" "$URL" > "${WORKSPACE}"/out.xml
  if [ "$VERBOSE" == "true" ]  
  then 
   cat  "${WORKSPACE}"/out.xml >> "${WORKSPACE}"/outs.xml
  fi
}

function extract {
  	export ${2}="`jq -r .${1} "${WORKSPACE}"/out.json`"
		echovv "export ${2}=${!2}."
}

function extractMap {
 mapfile -t ${2} < <(jq -r .result[].${1} "${WORKSPACE}/out.json")
}

function extractComponentMap {
 mapfile -t ${2} < <(jq -r .componentInfo[].${1} "${WORKSPACE}/out.json")
}

#Echo from other scripts
function echov {
  if [ "$VERBOSE" == "true" ]  
  then 
   echo -e "${BASH_SOURCE[1]}: ${1}"
  fi
}

#Echo from common.sh
function echovv {
  if [ "$VERBOSE" == "true" ]  
  then 
   echo -e "${BASH_SOURCE[2]}: ${1}"
  fi
}

function printReportHead {
  printf "<!DOCTYPE html>"
	printf "%s\n" "<html lang='en'>"
	printf "%s\n" "<head>"
  printf "%s\n" "<title>${REPORT_TITLE}</title>"
	printf "%s\n" "<style>"
  printf "%s\n" "table {"
  printf "\t%s\n" "font-family: arial, sans-serif;"
  printf "\t%s\n" "border-collapse: collapse;"
  printf "\t%s\n" "width: 100%;"
  printf "%s\n" "}"

  printf "%s\n" "td, th {"
  printf "\t%s\n" "border: 1px solid #dddddd;"
  printf "\t%s\n" "text-align: left;"
  printf "\t%s\n" "padding: 8px;"
  printf "%s\n" "}"

  printf "%s\n" "tr:nth-child(even) {"
  printf "\t%s\n" "background-color: #dddddd;"
  printf "%s\n" "}"
  printf "%s\n" "</style>"
  printf "%s\n" "</head>"
  printf "%s\n" "<body>"
 
  printf "%s\n" "<h2>${REPORT_TITLE}</h2>"
 
  printf "%s\n" "<table>"
  printf "%s\n" "<caption><h3>List of ${REPORT_TITLE}</h3></caption>"
  printf "%s\n" "<tr>"	
  for i in "${REPORT_HEADERS[@]}"
   do
			printf "%s\n" "<th scope='row'>${i}</th>"
	 done	
	printf "%s\n\n" "</tr>"
}

function printReportTail {
	printf "\n\n%s\n" "</table>"
  printf "%s\n" "</body>"
  printf "%s\n" "</html>"
}

function printReportRow {
	printFormat="%s\\n"
	printText="<tr>"
  l=0
	for FIELD in "$@"
	do		
	 printFormat="${printFormat}%s"
	 printText="${printText} <th scope='row'>${FIELD}</th>"
	 l=$(( $l + 1));
	done	
	printFormat="${printFormat}%s"
	printText="${printText} </tr>"
	printf "${printFormat} ${printText}"
}


function handleXmlComponents {
	extractComponentXmlFolder="$1"
	tag="${2}"
	notes="${3}"


	# Tag all the packages of the release together
	if [ ! -z "${extractComponentXmlFolder}" ] && [ null != "${extractComponentXmlFolder}" ] && [ "" != "${extractComponentXmlFolder}" ]
	then
  	folder="${WORKSPACE}/${extractComponentXmlFolder}"
  	#	 Save componentExtractFolder into git
    if [ ! -z "${tag}" ] && [ null != "${tag}" ] && [ "" != "${tag}" ]
        then
   				bin/publishCodeReviewReport.sh COMPONENT_LIST_FILE="${WORKSPACE}/${extractComponentXmlFolder}/${extractComponentXmlFolder}.list" GIT_COMMIT_ID="master" > "${WORKSPACE}/${extractComponentXmlFolder}_CodeReviewReport.html"
          bin/sonarScanner.sh baseFolder="${folder}"
          bin/gitPush.sh baseFolder="${folder}" tag="${tag}" notes="${notes}"
    		fi
   fi
	 
}


function printExtensions {
	if [ ! -z "${extensionJson}" ]
	then
	  #echo "----Begin Extensions----"
    echo "${extensionJson}" > "${WORKSPACE}/${extractComponentXmlFolder}.json"
    #echo "---- End Extension -----"
	fi
}

# Extension function to retrieve value
function getValueFrom {
   export extensionValue=${!1}
	# export extensionValue=$(aws secretsmanager get-secret-value --secret-id ${1} | jq -r .SecretString)
}
