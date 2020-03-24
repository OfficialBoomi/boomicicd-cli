#!/bin/bash
source bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env classification atomName roleName purgeHistoryDays)
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
saveAtomName="${atomName}"

source bin/createEnvironment.sh env="${env}" classification="${classification}"
saveEnvId=${envId}

source bin/createEnvironmentRole.sh env="${saveEnv}" roleName="${roleName}"
source bin/queryAtom.sh atomName="${atomName}" atomType="*" atomStatus="*"

if [ -z "$atomId" ] || [ "$atomId" == "null" ]
then
	return 255;
fi

saveAtomId=${atomId}
source bin/updateAtom.sh atomId=${atomId} purgeHistoryDays="${purgeHistoryDays}"
source bin/createAtomAttachment.sh atomId=${saveAtomId} envId=${saveEnvId}
clean
atomName="${saveAtomName}"

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
