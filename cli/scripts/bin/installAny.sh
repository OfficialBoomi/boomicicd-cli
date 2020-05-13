#!/bin/bash

atomType="ATOM"
env=
classification=TEST
atomName=


# for shared web URL
sharedWebURL="https:\/\/url.com"
apiType=advanced
apiAuth=${basic}

# for cloud molecule
cloudId=


roleName=Administrator
purgeHistoryDays=1
TMP_DIR=/usr/local/boomi/tmp
WORK_DIR=/usr/local/boomi/work
JAVA_HOME=/usr/bin/java
JRE_HOME=/usr/lib/jvm/jre
INSTALL_DIR=/usr/local/boomi/

# optional leave blank
proxyHost=
proxyPort=
proxyUser=
proxyPassword=


if [[ "$atomType" = "ATOM" ]]
	then
		ATOM_HOME=${INSTALL_DIR}/Atom_${atomName}
		source bin/installerToken.sh atomType=${atomType}
		./bin/installAtom.sh atomName="${atomName}" tokenId="${tokenId}" INSTALL_DIR="${INSTALL_DIR}" JRE_HOME="${JRE_HOME}" JAVA_HOME="${JAVA_HOME}" proxyHost="${proxyHost}" proxyPort="${proxyPort}" proxyUser="${proxyUser}" proxyPassword="${proxyPassword}"
		source bin/createEnvAndAttachRoleAndAtom.sh env="${env}" classification=${classification} atomName="${atomName}" roleName="${roleName}" purgeHistoryDays="${purgeHistoryDays}" 
		source bin/updateSharedServer.sh atomName="${atomName}" overrideUrl=true url="${sharedWebURL}" apiType="${apiType}" auth="${apiAuth}"

	elif [[ "$atomType" = "CLOUD" ]]
	then
		ATOM_HOME=${INSTALL_DIR}/Cloud_${atomName}
		source bin/installerToken.sh atomType=${atomType} cloudId=$cloudId
		./bin/installCloud.sh atomName="${atomName}" tokenId="${tokenId}" INSTALL_DIR="${INSTALL_DIR}" WORK_DIR="${WORK_DIR}" TMP_DIR="${TMP_DIR}" JRE_HOME="${JRE_HOME}" JAVA_HOME="${JAVA_HOME}" proxyHost="${proxyHost}" proxyPort="${proxyPort}" proxyUser="${proxyUser}" proxyPassword="${proxyPassword}"
		source bin/updateSharedServer.sh atomName="${atomName}" overrideUrl=true url="${sharedWebURL}" apiType="${apiType}" auth="${apiAuth}"		
		
	elif [[ "$atomType" = "BROKER" ]]
	then
		ATOM_HOME=${INSTALL_DIR}/Broker_${atomName}
		source bin/installerToken.sh atomType=${atomType}
		./bin/installBroker.sh atomName="${atomName}" tokenId="${tokenId}" INSTALL_DIR="${INSTALL_DIR}" WORK_DIR="${WORK_DIR}" TMP_DIR="${TMP_DIR}" JRE_HOME="${JRE_HOME}" JAVA_HOME="${JAVA_HOME}" proxyHost="${proxyHost}" proxyPort="${proxyPort}" proxyUser="${proxyUser}" proxyPassword="${proxyPassword}"
		
	elif [[ "$atomType" = "GATEWAY" ]]
	then
		ATOM_HOME=${INSTALL_DIR}/Gateway_${atomName}
		source bin/installerToken.sh atomType=${atomType}
		./bin/installGateway.sh atomName="${atomName}" tokenId="${tokenId}" INSTALL_DIR="${INSTALL_DIR}" WORK_DIR="${WORK_DIR}" TMP_DIR="${TMP_DIR}" JRE_HOME="${JRE_HOME}" JAVA_HOME="${JAVA_HOME}" proxyHost="${proxyHost}" proxyPort="${proxyPort}" proxyUser="${proxyUser}" proxyPassword="${proxyPassword}"

	elif [[ "$atomType" = "MOLECULE" ]]
	then	
		ATOM_HOME=${INSTALL_DIR}/Molecule_${atomName}
		source bin/installerToken.sh atomType=${atomType}
		./bin/installMolecule.sh atomName="${atomName}" tokenId="${tokenId}" INSTALL_DIR="${INSTALL_DIR}" WORK_DIR="${WORK_DIR}" TMP_DIR="${TMP_DIR}" JRE_HOME="${JRE_HOME}" JAVA_HOME="${JAVA_HOME}" proxyHost="${proxyHost}" proxyPort="${proxyPort}" proxyUser="${proxyUser}" proxyPassword="${proxyPassword}"
		source bin/createEnvAndAttachRoleAndAtom.sh env="${env}" classification=${classification} atomName="${atomName}" roleName="${roleName}" purgeHistoryDays="${purgeHistoryDays}" 
		source bin/updateSharedServer.sh atomName="${atomName}" overrideUrl=true url="${sharedWebURL}" apiType="${apiType}" auth="${apiAuth}"
	else
		echo "Invalid AtomType"
		exit 255
fi
	
${ATOM_HOME}/bin/atom restart


