#!/bin/bash

set -e 
source bin/common.sh
SCRIPTS_FOLDER=`pwd`

# mandatory arguments
ARGUMENTS=(baseFolder tag notes)

inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi						


git config --global user.email "${gitUserEmail}"
git config --global user.name  "${gitUserName}"


git clone "${gitRepoURL}"
cp -R "${baseFolder}"/* "${gitRepoName}"
cd "${gitRepoName}"
git add .
git commit -m "${notes}"
#git tag -a "${tag}" -m "${notes}"
git push 

cd ${SCRIPTS_FOLDER}
rm -rf  "${gitRepoName}"  "${baseFolder}"
