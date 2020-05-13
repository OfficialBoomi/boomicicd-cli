#!/bin/bash

set -e 

if [ "${gitOption}" = "CLONE" ]
then
   bin/gitClone.sh "$@"
else
  bin/gitRelease.sh "$@"
fi
