#!/bin/bash
set -e
source bin/common.sh

# mandatory arguments
ARGUMENTS=(baseFolder) 
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

if [ ! -z ${sonarHostURL} ]
then
 echov "Running sonarscanner for components under ${baseFolder}."
 if [ -z "${SONAR_HOME}" ]
 then
  unzip  -qn  ../../sonarqube/sonar-scanner*.zip
	SONAR_HOME="./sonar-scanner-4.2.0.1873-linux"
 fi 
 
 cd "${SONAR_HOME}"/bin
 ./sonar-scanner \
  -Dsonar.projectKey="${sonarProjectKey}" \
  -Dsonar.projectBaseDir="${baseFolder}" \
  -Dsonar.sources="${baseFolder}" \
  -Dsonar.host.url="${sonarHostURL}" \
  -Dsonar.login="${sonarToken}"
 
 cd "${WORKSPACE}"    
fi

clean
