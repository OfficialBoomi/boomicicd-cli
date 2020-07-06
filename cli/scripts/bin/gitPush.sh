#!/bin/bash


if [ "${gitOption}" = "CLONE" ]
then
   bin/gitClone.sh "$@"
else
  bin/gitRelease.sh "$@"
fi
