#!/bin/bash
source bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env classification atomName roleName cloudId purgeHistoryDays)
if [ -z "${purgeHistoryDays}" ]
then
        purgeHistoryDays=30
fi
inputs "$@"

if [ "$?" -gt "0" ]
then
        return 255;
fi
saveEnv=${env}

source bin/createEnvironment.sh env="${env}" classification="${classification}"
saveEnvId=${envId}

source bin/createEnvironmentRole.sh env="${saveEnv}" roleName="${roleName}"
source bin/createAtom.sh atomName="${atomName}" cloudId="${cloudId}"
saveAtomId=${atomId}

source bin/updateAtom.sh atomId=${atomId} purgeHistoryDays=7
source bin/createAtomAttachment.sh atomId=${saveAtomId} envId=${saveEnvId}
clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
