# Command Line Interface reference implementation for Boomi CI/CD

The CLI utility wraps calls to [Boomi Atomsphere APIs](https://help.boomi.com/bundle/integration/page/r-atm-AtomSphere_API_6730e8e4-b2db-4e94-a653-82ae1d05c78e.html). Handles input and output JSON files and performance orchestration for deploying and managing Boomi runtimes, components and metadata required for CI/CD. 
  
## Pre-requistes
  - The CLI utility currently runs on any Unix OS and invokes BASH shell scripts
  - The CLI utility requires jq - JSON Query interpreter installed 
  
        # Using yum #
        $ yum install -y jq 
        ## Using apt
        $ apt-get install -y jq 

## Set up
Copy the scripts folder on to a Unix Machine. The scripts folder contains the following directories
- bin has the bash scripts for CLI
- conf has configuration files for Molecule installation 
- json has json templates used in the Atomsphere API calls.

Set the following variables before the scripts are invoked.

        $ SCRIPTS_HOME='/pathto/scripts'
        $ cd $SCRIPTS_HOME
        $ export accountId=company_account_uuid
        $ export authToken=BOOMI_TOKEN.username@company.com:aP1k3y02-mob1-b00M-M0b1-at0msph3r3aa
        $ export h1="Content-Type: application/json"
        $ export h2="Accept: application/json"
        $ export baseURL=https://api.boomi.com/api/rest/v1/$accountId
        $ export WORKSPACE=`pwd`
        
## Run your first script

        $ source bin/publishAtom.sh > index.html
    
## List of Interface

The followings script/ calls a single API. Arguments in *italics* are optional

| **SCRIPT_NAME** | **ARGUMENTS** | **JSON FILE** |**API/Action**| **Notes**|
| ------ | ------ | ------ | ------ | ------ |
changeAllListenersStatus.sh|atomName, atomType, action|changeAllListenersStatus.json|changeListenerStatus|Change Listener Status for all listeners in an atom
changeListenerStatus.sh|atomName, atomType, processName, , action|changeListenerStatus.json|changeListenerStatus|Change Listener Status for a single processName in an atom
createAtom.sh|atomName, cloudId|createAtom.json|Atom/create|Create Cloud Atom in $cloudId
createAtomAttachment.sh|atomId, envId|createAtomAttachment.json|EnvironmentAtomAttachment /create|Attach Atom to Environment
createDeployedPackage.sh|envId, packageId, notes, listenerStatus|createDeployedPackage.json|DeployedPackage /create|Deploy a Packaged Component in an Env
createEnvironment.sh|env, classification|createEnvironment.json|Environment/create|Create Env (only if does not exist)
createEnvironmentRole.sh|roleName, env|createEnvironmentRole.json|EnvironmentRole /create|Attach a Role to an Env
createPackagedComponent.sh|componentId, componentType, packageVersion, notes, createdDate|createPackagedComponent.json|PackagedComponent/create|Create a Packaged Component 
createProcessAttachment.sh|processId, envId, componentType|createProcessAttachment.json|ProcessEnvironmentAttachment /create|Attach Process to Environment (Legacy deployment)
deployPackage.sh|env, packageVersion, notes, listenerStatus, componentId or processName|Muliple|Multiple|Creates and deploys a packaged component by processName or id in a given Env
deployProcess.sh|processId, envId, componentType, notes|deployProcess.json|Deployment/|Deploys a process to an env (Legacy Deployment)
executeProcess.sh|	atomName, atomType, componentId or *processName*| executeProcess.json|executeProcess| Executes a process on a named Boomi runtime
installerToken.sh|atomType, *cloudId*|installerToken.json|InstallerToken|Gets an installer token atomType must be one-of **ATOM**, **MOLECULE** or **CLOUD**. If atomType=CLOUD then the cloudId must be specified
promoteProcess.sh|from, to, processName, current, version, listenerStatus|Muliple|Multiple|Promotes a process of a given version from an Env to another Env (Legacy deployment)
queryAtom.sh|atomName, atomType, atomStatus|queryAtom.json|Atom/query|Queries Atom use atomType and atomStatus =* for wild card
queryAtomAttachment.sh|atomId, envId|queryAtomAttachment.json|EnvironmentAtomAttachment /query|Queries an Atom/Env Attachment
queryDeployedPackage.sh|envId, packageId|queryDeployedPackage.json|DeployedPackage /query|Queries a deployed Packaged Component in an Env
queryDeployment.sh|processId, envId, current, version|queryDeployment.json|Deployment/query|Queries a deployment in an Env (Legacy deployment)
queryEnvironment.sh|env, classification|queryEnvironment.json|Environment/query|Queries an Env in an Account. Use classification=* for wildcard.
queryExecutionRecord.sh|from, to, atomName|queryExecutionRecord.json|ExecutionRecord /query|Queries Process Execution records within a given time span
queryPackagedComponent.sh|componentId, componentType, packageVersion|queryPackagedComponent.json|PackagedComponent /query|Queries a Packaged Component by version and Process Name
queryProcess.sh|processName|queryProcess.json|Process/query|Queuries a process to get ComponentId 
queryProcessAttachment.sh|processId, envId, componentType|queryProcessAttachment.json|ProcessEnvironmentAttachment /query|Queries a Process Deployment in an Env (Legacy deployment)
queryProcessScheduleStatus.sh|atomName, atomType, processName|queryProcessScheduleStatus.json|ProcessScheduleStatus /query|Queries Process Schedule Status in a runtime
queryProcessSchedules.sh|atomName, atomType, processName|queryProcessSchedules.json|ProcessSchedules /query|Queries Process Schedules in a runtime
queryRole.sh|roleName|queryRole.json|Role/query|Queries a role exists
updateAtom.sh|atomId, purgeHistoryDays|updateAtom.json|Atom/$atomId/update|Update atom properties (purgeHistory)
updateProcessScheduleStatus.sh|atomName, atomType, processName, status|updateProcessScheduleStatus.json|ProcessScheduleStatus /$scheduleId /update|Updates Process Schedule Status
updateProcessSchedules.sh|atomName, atomType, processName, years, months, daysOfMonth, daysOfWeek, hours, minutes|updateProcessSchedules.json|ProcessSchedules /$scheduleId /update|Updates Single Process Schedule (For advance options use the UI)
updateSharedServer.sh|atomName, overrideUrl, apiType, auth, url|updateSharedServer.json|SharedServerInformation /$atomId /update|Updates Shared Web Server URL and APIType


The following scripts publish html reports
| **SCRIPT_NAME** | **ARGUMENTS** | **REPORT HEADERS** | **Notes**|
| ------ | ------ | ------ | ------ |
publishAllEnvironments.sh|-|Id, Classification, Name|Publishes a list of  Environments in the account
publishAtom.sh|-|Atom Id, Atom Name, Env, Name, Status|Publishes a list of Atoms and attached Env in the account
publishDeployedPackage.sh|env=%env%|Component, Package Version, Environment, Component Type, Deployed Date, Deployed By, Notes|Publishes a list of Deployed Packaged in an Env
publishPackagedComponent.sh|packageVersion=%version%|Component, Package Version, Component Type, Deployed Date, Deployed By, Notes|Publishes a list of Packaged Component for a given version
publishProcess.sh|processName=%%|Process Id, Process Name|Publishes a list of Processes  in the account


- The following scripts installs Boomi runtimes (local to the script location).
- Before running the script set the tokenId variable by running the installerToke.sh CLI script.
| **SCRIPT_NAME** | **Usage**|
| ------ | ------ |
installAtom.sh|bin/installAtom.sh atomName=${atomName} tokenId=${tokenId} *INSTALL_DIR=${INSTALL_DIR}*
installMolecule.sh|bin/installMolecule.sh atomName=${atomName} tokenId=${tokenId} *INSTALL_DIR=${INSTALL_DIR} WORK_DIR=${WORK_DIR} JRE_HOME=${JRE_HOME} JAVA_HOME=${JAVA_HOME} TMP_DIR=${TMP_DIR}*||Installs the Molecule runtime locally
installCloud.sh|bin/installCloud.sh atomName=${atomName} cloudId=${cloudId} tokenId=${tokenId} *INSTALL_DIR=${INSTALL_DIR} WORK_DIR=${WORK_DIR} JRE_HOME=${JRE_HOME} JAVA_HOME=${JAVA_HOME} TMP_DIR=${TMP_DIR}*||Publishes a list of Deployed Packaged in an Env


## common. sh


