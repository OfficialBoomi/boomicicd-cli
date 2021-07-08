#!/bin/bash
source bin/common.sh

# No verbose for this script
saveVerbose=${VERBOSE}
unset VERBOSE
export VIOLATIONS_FOUND="false"
# mandatory arguments
ARGUMENTS=(baseFolder)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
REPORT_TITLE="Packaged Components Code Quality Report"
REPORT_HEADERS=("#" "Component ID" "Name" "Version" "Type" "Issue" "Issue Type" "Priority")
rules=`cat "${sonarRulesFile}" | xmllint -xpath 'count(profile/rules/rule)' -`
printReportHead
h=0
find "${baseFolder}" -name "*.xml" | while read componentFile
do
 componentId=$( cat "${componentFile}" | sed -e 's/bns://g' | xmllint --xpath "string(/Component/@componentId)" - )
 componentName=$( cat "${componentFile}" | sed -e 's/bns://g' | xmllint --xpath "string(/Component/@name)" - )
 componentVersion=$( cat "${componentFile}" | sed -e 's/bns://g' | xmllint --xpath "string(/Component/@version)" - )
 componentType=$( cat "${componentFile}" | sed -e 's/bns://g' | xmllint --xpath "string(Component/@type)" - ) 
 for (( i=1; i<=${rules}; i++ ))
  do 
   xpath="`cat "${sonarRulesFile}" | xmllint -xpath 'profile/rules/rule['$i']/parameters/parameter/key[text()="expression"]/../value/text()' -`"
   fail=`cat "${componentFile}" | sed -e 's/bns://g' | xmllint --xpath "$xpath" - 2> /dev/null | wc -c`
   if [ "${fail}" -gt 0 ];  then
		 export VIOLATIONS_FOUND="true"
		 vPriority="`cat "${sonarRulesFile}" | xmllint -xpath 'profile/rules/rule['$i']/priority/text()' -`" ;
		 vType="`cat "${sonarRulesFile}" | xmllint -xpath 'profile/rules/rule['$i']/type/text()' -`" ;
		 vName=`cat "${sonarRulesFile}" | xmllint -xpath 'profile/rules/rule['$i']/description/text()' -` ;
		 h=$(( $h + 1 ));
		 printReportRow "${h}" "${componentId}" "${componentName}" "${componentVersion}" "${componentType}" "${vName}" "${vType}" "${vPriority}" ;
   fi
 done
done

printReportTail
clean
export VERBOSE=${saveVerbose}
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
