#!/bin/bash
source bin/common.sh

# mandatory arguments
ARGUMENTS=(packageVersion notes) 
OPT_ARGUMENTS=(componentId processName extractComponentXmlFolder componentVersion tag componentType)

inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi


if [ ! -z "${extractComponentXmlFolder}" ]
then
 folder="${WORKSPACE}/${extractComponentXmlFolder}"
 rm -rf ${folder}
 unset extensionJson
 saveExtractComponentXmlFolder="${extractComponentXmlFolder}"
fi

saveNotes="${notes}"
saveTag="${tag}"

source bin/createSinglePackage.sh "$@"

handleXmlComponents "${saveExtractComponentXmlFolder}" "${saveTag}" "${saveNotes}"


if [ "$ERROR" -gt 0 ]
 then
    return 255;
fi
