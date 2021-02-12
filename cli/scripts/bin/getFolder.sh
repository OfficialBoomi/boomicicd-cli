#!/bin/bash

#########################################################
# This script gets the full folder path of the folderId #
#########################################################

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
unset version
ARGUMENTS=(folderId)
inputs "$@"

if [ "$?" -gt "0" ]
then
   return 255;
fi


export URL=$baseURL/folder/${folderId}

getAPI

extract fullPath fullPath
extract deleted isFolderDeleted 

clean

