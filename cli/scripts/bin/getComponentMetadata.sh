#!/bin/bash

######################################################
# This scripts get the component metadata details    #
######################################################

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
unset version
ARGUMENTS=componentId
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

export URL=$baseURL/ComponentMetadata/${componentId}${version}

getAPI

extract componentId componentId
extract name name
extract type type 
extract subType subType
extract version myversion
extract currentVersion currentVersion
extract folderId folderId
extract folderName folderName
extract modifiedBy modifiedBy

clean

export version=${myversion}

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
