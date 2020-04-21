#!/bin/bash

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
   echo "ARGUMENTS"
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
	 unset JSON_FILE ARGUMENTS id URL var ARGUMENT i exportVariable reportHeaders reportTitle OPT_ARGUMENTS
	 #rm -f "${WORKSPACE}"/*.json
}

# call platform API
function callAPI {
	unset ERROR ERROR_MESSAGE
  #echo "curl -s -X POST -u $authToken -H \"${h1}\" -H \"${h2}\" $URL -d@tmp.json > out.json"
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

}

function getAPI {
	unset ERROR ERROR_MESSAGE
  curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" "$URL" > "${WORKSPACE}"/out.json
  export ERROR=`jq  -r . "${WORKSPACE}"/out.json  |  grep '"@type": "Error"' | wc -l`
  if [[ $ERROR -gt 0 ]]; then 
	  export ERROR_MESSAGE=`jq -r .message "${WORKSPACE}"/out.json` 
		echo $ERROR_MESSAGE 
	 return 251
  fi
}

function getXMLAPI {
	unset ERROR ERROR_MESSAGE
	export ERROR=0
  export ERROR_MESSAGE=""
  curl -s -X GET -u $authToken -H "application/xml" -H "application/xml" "$URL" > "${WORKSPACE}"/out.xml
}

function extract {
  	export ${2}="`jq -r .${1} "${WORKSPACE}"/out.json`"
}

function extractMap {
 mapfile -t ${2} < <(jq -r .result[].${1} "${WORKSPACE}/out.json")
}

function extractComponentMap {
 mapfile -t ${2} < <(jq -r .componentInfo[].${1} "${WORKSPACE}/out.json")
}

function printReportHead {
	printf "%s\n" "<html>"
	printf "%s\n" "<head>"
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
  printf "%s\n" "<tr>"	
  for i in "${REPORT_HEADERS[@]}"
   do
			printf "%s\n" "<th>${i}</th>"
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
	 printText="${printText} <th>${FIELD}</th>"
	 l=$(( $l + 1));
	done	
	printFormat="${printFormat}%s"
	printText="${printText} </tr>"
	printf "${printFormat} ${printText}"
}
