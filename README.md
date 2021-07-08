# Command Line Interface reference implementation for Boomi CI/CD

The CLI utility wraps calls to [Boomi Atomsphere APIs](https://help.boomi.com/bundle/integration/page/r-atm-AtomSphere_API_6730e8e4-b2db-4e94-a653-82ae1d05c78e.html). Handles input and output JSON files and performance orchestration for deploying and managing Boomi runtimes, components and metadata required for CI/CD. 
  
## Pre-requistes
  - The CLI utility currently runs on any Unix OS and invokes BASH shell scripts
  - On Windows this has been tested with [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
  - Boomi Atomsphere API token to be generated [link](https://help.boomi.com/bundle/integration/page/int-AtomSphere_API_Tokens_page.html)
  - The CLI utility requires jq - JSON Query interpreter installed 
  - The CLI requires xmllit interpreter 
  
        ## Using yum 
        $ yum install -y jq 
        $ yum install -y libxml2
        
        ## Using apt
        $ apt-get install -y jq 
        $ apt-get install libxml2-utils

## Set up
Clone the scripts folder on to a Unix Machine. The scripts folder contains the following directories. 

    $ git clone https://github.com/OfficialBoomi/boomicicd-cli.git
    $ cd boomicicd-cli/cli/scripts


- **bin** has the bash scripts for CLI
- **conf** has configuration files for Molecule installation 
- **json** has json templates used in the Atomsphere API calls.
- **templates/azure-pipelines** has yaml templates used to create Azure pipelines
- **templates/configuration** has json templates used to trigger Boomi jobs using a metadata file, configuration as code.
- Check this link to create the authToken [link](https://help.boomi.com/bundle/integration/page/int-AtomSphere_API_Tokens_page.html)

        $ # Set the following variables before the scripts are invoked. 
        $ Or Update in the bin/exports.sh and run source bin/exports
        $ source bin/exports.sh 
        
        $ # Get values from user or parameter store
        $ # The following credentials can be stored in parameter store and retrieved dynamically
        $ # Example to retrieve form an AWS store "$(aws ssm get-parameter --region xx --with-decryption --output text --query Parameter.Value --name /Parameter.name)
        
        $ SCRIPTS_HOME='/pathto/scripts'
        $ cd $SCRIPTS_HOME
        $ export accountId=company_account_uuid
        $ export authToken=BOOMI_TOKEN.username@company.com:aP1k3y02-mob1-b00M-M0b1-at0msph3r3aa        
        $ export h1="Content-Type: application/json"
        $ export h2="Accept: application/json"
        $ export baseURL=https://api.boomi.com/api/rest/v1/$accountId
        $ export WORKSPACE=$(pwd)
               
        # Git Component stuff -> This is where the component xmls will be stored
        $ export gitComponentRepoURL=""
        $ export gitComponentUserName=""
        $ export gitComponentUserEmail=""
        $ export gitComponentRepoName="BoomiComponents" # Top level folder of the GIT REPO
        $ export gitComponentOption="CLONE" # This clones the repo; else default is to create a release tag. Check gitPush.sh file
        $ export gitComponentCommitPath="/tree/master/" # For Azure Repos use this "?version=GBmaster&path=" this is used in code review report to construct the path
        $ export gitCLIRepoName="BoomiCLI" # Name of this repo in CLI this will be used in AzureReleasePipeline task
        $ export gitReleaseRepoName="BoomiRelease" # Name of the Release Repo will be used in AzureReleasePipeline task
        
        # Sonar stuff
        $ export SONAR_HOST=""  # If sonar scanner is installed locally then will use the local sonar scanner. Check the sonarScanner.sh
        $ export sonarHostURL=""
        $ export sonarHostToken=""
        $ export sonarProjectKey="BoomiSonar"
        $ export sonarRulesFile="conf/BoomiSonarRules.xml"
        $ export VERBOSE="false" # Bash verbose output; set to true only for testing.
        $ export SLEEP_TIMER=0.2 # Delays curl request to the platform to set the rate under 5 requests/second

        

        
## Run your first script

        $ source bin/exports.sh
        $ source bin/publishAtom.sh > index.html
    
## List of Interfaces

The followings script/ calls a single API. Arguments in *italics* are optional

| **SCRIPT_NAME** | **ARGUMENTS** | **JSON FILE** |**API/Action**| **Notes**|
| ------ | ------ | ------ | ------ | ------ |
|changeAllListenersStatus.sh|atomName, atomType, action|changeAllListenersStatus.json|changeListenerStatus|Change Listener Status for all listeners in an atom|
|changeListenerStatus.sh|atomName, atomType, processName, , action|changeListenerStatus.json|changeListenerStatus|Change Listener Status for a single processName in an atom|
|createAtom.sh|atomName, cloudId|createAtom.json|Atom/create|Create Cloud Atom in $cloudId|
|createAtomAttachment.sh|atomId, envId|createAtomAttachment.json|EnvironmentAtomAttachment /create|Attach Atom to Environment|
|createDeployedPackage.sh|envId, packageId, notes, listenerStatus|createDeployedPackage.json|DeployedPackage /create|Deploy a Packaged Component in an Env|
|createEnvironment.sh|env, classification|createEnvironment.json|Environment/create|Create Env (only if does not exist)|
|createEnvironmentRole.sh|roleName, env|createEnvironmentRole.json|EnvironmentRole /create|Attach a Role to an Env|
|createPackages.sh|packageVersion, notes, componentType, componentIds or processNames, extractComponentXmlFolder|Muliple|Multiple|Creates multiple PackagedComponents using the currentVersion processName or id. If the extractComponentXmlFolder if passed all the component XML and package manifest files are extracted into the folder|
|createPackage.sh|packageVersion, notes, componentType, componentVersion, componentId or processName, extractComponentXmlFolder,tag|Muliple|Multiple|Creates a PackagedComponent by processName or componentid. If the extractComponentXmlFolder if passed all the component XML and package manifest files are extracted into the folder|
|createPackagedComponent.sh|componentId, componentType, packageVersion, notes, componentVersion createdDate|createPackagedComponent.json|PackagedComponent/create|Create a Packaged Component| 
|createProcessAttachment.sh|processId, envId, componentType|createProcessAttachment.json|ProcessEnvironmentAttachment /create|Attach Process to Environment (Legacy deployment)|
|deployPackage.sh|env, packageVersion, notes, listenerStatus, componentType, componentVersion, componentId or processName, extractComponentXmlFolder,tag|Muliple|Multiple|Creates and deploys a PackagedComponent by processName or componentid in a given Env. If the extractComponentXmlFolder if passed all the component XML and package manifest files are extracted into the folder|
|deployPackages.sh|env, packageVersion, notes, listenerStatus, componentType, componentIds or processNames, extractComponentXmlFolder, tag|Muliple|Multiple|Creates and deploys multiple packaged component using the currentVersion processName or id to an env. If the extractComponentXmlFolder if passed all the component XML and package manifest files are extracted into the folder|
|dynamicJenkinsGitJobBuilder.sh|GIT_COMMIT_ID|Muliple|Multiple|Reads a JSON configuration file (*\*.conf* extension) that was added/updated as part of the GIT COMMIT and calls Jenkins jobs based the pipeline template. The templates are defined in the templates/configurations folder|
|dynamicScripGitJobBuilder.sh|GIT_COMMIT_ID|Muliple|Multiple|Sames as above reads a JSON configuration file (*\*.conf* extension) that was added/updated as part of the GIT COMMIT and calls cli scripts based the pipeline template. The templates are defined in the templates/configurations folder|
|dynamicScriptJobBuilder.sh|file|Muliple|Multiple|Sames as above directly reads a JSON configuration file (*\*.conf* extension) and calls cli scripts based the pipeline template. The templates are defined in the templates/configurations folder|
|deployProcess.sh|processId, envId, componentType, notes|deployProcess.json|Deployment/|Deploys a process to an env (Legacy Deployment)|
|executeProcess.sh|	atomName, atomType, componentId or *processName*| executeProcess.json|executeProcess| Executes a process on a named Boomi runtime|
|installerToken.sh|atomType, *cloudId*|installerToken.json|InstallerToken|Gets an installer token atomType must be one-of **ATOM**, **MOLECULE** or **CLOUD**. If atomType=CLOUD then the cloudId must be specified|
|promoteProcess.sh|from, to, processName, current, version, listenerStatus|Muliple|Multiple|Promotes a process of a given version from an Env to another Env (Legacy deployment)|
|queryAtom.sh|atomName, atomType, atomStatus|queryAtom.json|Atom/query|Queries Atom use atomType and atomStatus =* for wild card|
|queryAtomAttachment.sh|atomId, envId|queryAtomAttachment.json|EnvironmentAtomAttachment /query|Queries an Atom/Env Attachment|
|queryDeployedPackage.sh|envId, packageId|queryDeployedPackage.json|DeployedPackage /query|Queries a deployed Packaged Component in an Env|
|queryDeployment.sh|processId, envId, current, version|queryDeployment.json|Deployment/query|Queries a deployment in an Env (Legacy deployment)|
|queryEnvironment.sh|env, classification|queryEnvironment.json|Environment/query|Queries an Env in an Account. Use classification=* for wildcard.|
|queryExecutionRecord.sh|from, to, atomName|queryExecutionRecord.json|ExecutionRecord /query|Queries Process Execution records within a given time span|
|queryPackagedComponent.sh|componentId, componentType, packageVersion|queryPackagedComponent.json|PackagedComponent /query|Queries a Packaged Component by version and Process Name|
|queryProcess.sh|processName|queryProcess.json|Process/query|Queuries a process to get ComponentId|
|queryProcessAttachment.sh|processId, envId, componentType|queryProcessAttachment.json|ProcessEnvironmentAttachment /query|Queries a Process Deployment in an Env (Legacy deployment)|
|queryProcessScheduleStatus.sh|atomName, atomType, processName|queryProcessScheduleStatus.json|ProcessScheduleStatus /query|Queries Process Schedule Status in a runtime|
|queryProcessSchedules.sh|atomName, atomType, processName|queryProcessSchedules.json|ProcessSchedules /query|Queries Process Schedules in a runtime|
|queryRole.sh|roleName|queryRole.json|Role/query|Queries a role exists|
|updateAtom.sh|atomId, purgeHistoryDays|updateAtom.json|Atom/$atomId/update|Update atom properties (purgeHistory)|
|updateProcessScheduleStatus.sh|atomName, atomType, processName, status|updateProcessScheduleStatus.json|ProcessScheduleStatus /$scheduleId /update|Updates Process Schedule Status|
|updateExtensions.sh|extensionJson, envId or env|User supplied JSON file|EnvironmentExtensions $envId/update|Updates the environment extension. The extension values can be passed as strings value="string" or as valueFrom="lookup_value"|
|updateProcessScheduleStatus.sh|atomName, atomType, processName, status|updateProcessScheduleStatus.json|ProcessScheduleStatus /$scheduleId /update|Updates Process Schedule Status|
|updateProcessSchedules.sh|atomName, atomType, processName, years, months, daysOfMonth, daysOfWeek, hours, minutes|updateProcessSchedules.json|ProcessSchedules /$scheduleId /update|Updates Single Process Schedule (For advance options use the UI)|
|updateSharedServer.sh|atomName, overrideUrl, apiType, auth, url|updateSharedServer.json|SharedServerInformation /$atomId /update|Updates Shared Web Server URL and APIType|


### Updating Environment Extensions 
Boomi platform APIs support updating partial or full environment extensions. There are two CLI functions built in to support environment extensions. 

1. The Create/Deploy Package CLIs scans the component XML to create the JSON required to call the update extension function. The developer needs to review the JSON and update the extensions values. The extension values can be passed as clear string or derived strings. If looking up extension from an external entity like SecretManager this has to be address in the common.sh#getValueFrom function. In this version the extension JSON is only created for Connection & Dynamic Process Properties extended by the Process, more types will be supported in future release.

2. The extension JSON generated in the previous step can be used to updateExtension.sh CLI. The updateExtension CLI supports all extension types, the get Environment Extension can also be used (here https://help.boomi.com/bundle/integration/page/int-Environment_extensions_object.html) to generate the extension JSON. When using valueFrom attribute to update secret or other variables review the common.sh | getValueFrom function to ensure it meets your need.


## List of Reports
The following scripts publish html reports
| **SCRIPT_NAME** | **ARGUMENTS** | **REPORT HEADERS** | **Notes**|
| ------ | ------ | ------ | ------ |
|publishAllEnvironments.sh|-|Id, Classification, Name|Publishes a list of  Environments in the account|
|publishAtom.sh|-|Atom Id, Atom Name, Env, Name, Status|Publishes a list of Atoms and attached Env in the account|
|publishDeployedPackage.sh|env=%env%|Component, Package Version, Environment, Component Type, Deployed Date, Deployed By, Notes|Publishes a list of Deployed Packaged in an Env|
|publishComponentMetadata.sh|packageIds|ComponentId, Component Name, Component Type, Version, Folder Name, Modified by|Publishes Component Metadata details in a given package|
|publishPackagedComponent.sh|packageVersion=%version%|Component, Package Version, Component Type, Deployed Date, Deployed By, Notes|Publishes a list of Packaged Component for a given version|
|publishProcess.sh|processName=%%|Process Id, Process Name|Publishes a list of Processes  in the account|

## common. sh
The CLI framework is built around the functions in the common.sh
| **Function** | **Usage**|
| ------ | ------ |
|callAPI| Invokes the AtomSphere API and captures the output in out.json|
|call_script| This is used in the dynamicScript* jobs and interprets the configuration files to invoke CLI scripts dynamically|
|getAPI| Invokes the GET request on AtomSphere API and captures the output in out.json|
|getXMLAPI| Invokes the GET/XML request on AtomSphere API and captures the output in out.xml|
|clean| unsets input variables, retains output variables|
|createJSON| Creates the input JSON from the template JSON and ARGUMENTS in a tmp.json |
|extract| Exports specific variables in the envirnoment variable from out.json|
|extractMap| Exports specific array in the envirnoment variable from out.json |
|inputs|Parses the inputs and validates its against the mandatory ARGUMENTS |
|printReportHead| Prints report header. Called by the Publish report scripts|
|printReportRow|  Prints row data. Called by the Publish report scripts|
|printReportTail|  Prints report tail. Called by the Publish report scripts|
|usage| Prints the script usage details|
|getValueFrom| Used in the updateExtensions.sh to lookup secret values, this function needs to be changed for special usecases|

## Troubleshooting and help
- If a script fails to run, it will print the ERROR_MESSAGE and exit with an ERROR_CODE i.e. $? > 0
- Check the $WORKSPACE/tmp.json for the input.json
- Check the $WORKSPACE/out.json for the out.json
- Call the API manually using
- set the export VERBOSE="true" to see DEBUG messages
 curl -s -X POST -u $authToken -H "${h1}" -H "${h2}" $URL -d@"${WORKSPACE}"/tmp.json > "${WORKSPACE}"/out.json
 
 # Support
This image is not supported at this time. Please leave your comments at https://community.boomi.com/s/group/0F91W0000008r5WSAQ/devops-boomi.
