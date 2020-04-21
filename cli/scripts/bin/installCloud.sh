#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments

ARGUMENTS=(atomName cloudId tokenId INSTALL_DIR WORK_DIR JRE_HOME JAVA_HOME TMP_DIR)
OPT_ARGUMENTS=(proxyHost proxyPort proxyUser proxyPassword)

if [ -z "${INSTALL_DIR}" ]
then
      INSTALL_DIR=/var/boomi 
fi

if [ -z "${WORK_DIR}" ]
then
     WORK_DIR=/home/boomi/work 
fi

if [ -z "${JRE_HOME}" ]
then
     JRE_HOME=/usr/lib/jvm/jre 
fi

if [ -z "${JAVA_HOME}" ]
then
     JAVA_HOME=/usr/local/java 
fi

if [ -z "${TMP_DIR}" ]
then
     TMP_DIR=/tmp 
fi

inputs "$@"

if [ "$?" -gt "0" ]
then
       return 255;
fi

installDir=${INSTALL_DIR}
ATOM_HOME=$installDir/Cloud_$atomName

#-VproxyHost=<proxy_host_name> -VproxyUser=<proxy_user_name> 
#-VproxyPassword=<proxy_password> -VproxyPort=<proxy_port_number>

proxyParams=""
if [ ! -z "${proxyHost}" ]
then
  proxyParams="${proxyParams} -VproxyHost='${proxyHost}'"
fi

if [ ! -z "${proxyPort}" ]
then
  proxyParams="${proxyParams} -VproxyPort='${proxyPort}'"
fi

if [ ! -z "${proxyUser}" ]
then
   proxyParams="${proxyParams} -VproxyUser='${proxyUser}'"
fi

if [ ! -z "${proxyPassword}" ]
then
 proxyParams="${proxyParams} -VproxyPassword='${proxyPassword}'"
fi

../cloud_install64.sh -q -console  \
-VinstallToken=$tokenId \
-VatomName=$atomName \
-VlocalTempPath=${TMP_DIR} \
-dir $installDir \
-VcloudId=$cloudId \
-VjdkPath=${JAVA_HOME} ${proxyParams} \
-VlocalPath=${WORK_DIR}

# update container properties
input="conf/cloud_container.properties"
while IFS= read -r line; do echo "$line" >> ${ATOM_HOME}/conf/container.properties; done  < "$input"

echo "${JRE_HOME}" > $ATOM_HOME/.install4j/pref_jre.cfg

${ATOM_HOME}/bin/atom restart
