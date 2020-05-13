#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
unset version
ARGUMENTS=(componentId)
OPT_ARGUMENTS=version
inputs "$@"

if [ "$?" -gt "0" ]
then
   return 255;
fi

if [ "" != "$version" ]
then
	version="~$version"
else
	version=""
fi

export URL=$baseURL/Component/${componentId}${version}

getXMLAPI


cat "${WORKSPACE}"/out.xml | xmllint --format - > "${WORKSPACE}"/${componentId}.xml


clean

export version=${myversion}
