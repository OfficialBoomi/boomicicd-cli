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

cd "${baseFolder}"

git init
git config --global user.email "${gitComponentUserEmail}"
git config --global user.name  "${gitComponentUserName}"
git remote add origin "${gitComponentRepoURL}"
git add .
git commit -m "${tag}"
git tag -a "${tag}" -m "${notes}"
git push --set-upstream origin "${tag}"
cd "${SCRIPTS_FOLDER}"
