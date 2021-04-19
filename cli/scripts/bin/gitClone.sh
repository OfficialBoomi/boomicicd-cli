#!/bin/bash

source bin/common.sh
SCRIPTS_FOLDER=`pwd`

# mandatory arguments
ARGUMENTS=(baseFolder tag notes)

inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi						


git config --global user.email "${gitComponentUserEmail}"
git config --global user.name  "${gitComponentUserName}"


git clone "${gitComponentRepoURL}"
cp -R "${baseFolder}"/* "${gitComponentRepoName}"
cd "${gitComponentRepoName}"
git add .
git commit -m "${notes}"
#git tag -a "${tag}" -m "${notes}"
git push 

cd "${SCRIPTS_FOLDER}"
rm -rf  "${gitComponentRepoName}"  "${baseFolder}"
