#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments

ARGUMENTS=(atomType atomName)
OPT_ARGUMENTS=(INSTALL_DIR WORK_DIR JRE_HOME JAVA_HOME TMP_DIR proxyHost proxyPort proxyUser proxyPassword cloudId)

inputs "$@"
if [ "$?" -gt "0" ]
then
       return 255;
fi

atomCamel=`echo $atomType | sed 's/[^_]\+/\L\u&/g'`
atomUpper=`echo ${atomType^^}`
atomLower=`echo ${atomType,,}`

if [ -z "${INSTALL_DIR}" ]
then
      INSTALL_DIR=/usr/local/boomi/share/${atomLower}
fi

if [ -z "${WORK_DIR}" ]
then
     WORK_DIR=/usr/local/boomi/work 
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
     TMP_DIR=/usr/local/boomi/tmp 
fi


ATOM_HOME="${INSTALL_DIR}/${atomCamel}_$atomName"

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

printArgs

# fetch token
source bin/installerToken.sh atomType=${atomUpper} cloudId=${cloudId}

../${atomLower}_install64.sh -q -console  \
-VinstallToken=$tokenId \
-VatomName=$atomName \
-VlocalTempPath=${TMP_DIR} \
-dir ${INSTALL_DIR} \
-VjdkPath=${JAVA_HOME} ${proxyParams} \
-VlocalPath=${WORK_DIR}

# update container properties

echo "${JRE_HOME}" > $ATOM_HOME/.install4j/pref_jre.cfg

input="conf/${atomLower}_container.properties"
while IFS= read -r line; do echo "$line" >> ${ATOM_HOME}/conf/container.properties; done  < "$input"

${ATOM_HOME}/bin/atom restart
