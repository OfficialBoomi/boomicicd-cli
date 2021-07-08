#!/bin/bash


if [ "${gitComponentOption}" == "CLONE" ]
then
   bin/gitClone.sh "$@"
else
  bin/gitRelease.sh "$@"
fi
