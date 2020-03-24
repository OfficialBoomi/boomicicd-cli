#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments

ARGUMENTS=(atomName tokenId INSTALL_DIR)
OPT_ARGUMENTS=(proxyHost proxyPort proxyUser proxyPassword)

if [ -z "${INSTALL_DIR}" ]
then
      INSTALL_DIR=/var/boomi 
fi


inputs "$@"

if [ "$?" -gt "0" ]
then
       return 255;
fi

installDir=${INSTALL_DIR}
mkdir -p $installDir
ATOM_HOME=$installDir/Atom_$atomName

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

../atom_install64.sh -q -console  \
-VinstallToken=$tokenId \
-VatomName=$atomName ${proxyParams}\
-dir $installDir 
