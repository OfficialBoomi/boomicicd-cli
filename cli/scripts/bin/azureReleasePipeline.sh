# Write your commands here


# This set the variables used in Azure DevOps pipeline.
# Mostly constants
export h1="${H1}"
export h2="${H2}"

# Get values from user or parameter store
# The following credentials can be stored in parameter store and retrieved dynamically
# Example to retrieve form an AWS store "${aws ssm get-parameter --region xx --with-decryption --output text --query Parameter.Value --name /Parameter.name}
export accountName="${ACCOUNTNAME}"
export accountId=${ACCOUNTID}
# export authToken=${authToken} # Passed in as environment variable authToken=$(authToken)
# export gitRepoURL="${gitRepoURL}" # Passed in as environment variable
export gitUserName="${GITUSERNAME}"
export gitUserEmail="${GITUSEREMAIL}"
export sonarHostURL="${SONARHOSTURL}"
# export sonarHostToken="${sonarHostToken}" # Passed in as environment variable
export sonarProjectKey="${SONARPROJECTKEY}"
export gitRepoName="${GITREPONAME}" # Top level folder of the GIT REPO
export gitCommitPath="${GITCOMMITPATH}" # export gitCommitPath="?version=GBmaster&path=" this is used in code review report 
export sonarRulesFile="${SONARRULESFILE}"

# Keys that can change
export VERBOSE="${VERBOSE}" # Bash verbose output; set to true only for testing, will slow execution.
export SLEEP_TIMER="${SLEEP_TIMER}" # Delays curl request to the platform to set the rate under 5 requests/second
export gitOption="${GITOPTION}" # This clones the repo; else default is to create a release tag. Check gitPush.sh file
export SONAR_HOST=""  # If sonar scanner is installed locally then will use the local sonar scanner. Check the sonarScanner.sh file

# Derived keys
export baseURL=https://api.boomi.com/api/rest/v1/$accountId
export regressionTestURL="${REGRESSIONTESTURL}" # URL for regression test suite framework.
echo "Base URL is ${baseURL}"

HOME_DIR="${SYSTEM_ARTIFACTSDIRECTORY}/${RELEASE_PRIMARYARTIFACTSOURCEALIAS}"
echo "HOME DIR is ${HOME_DIR}"
cd "${HOME_DIR}/cli/scripts"
export WORKSPACE="$(pwd)"
echo "Executing script for file=${FILE} in WORKSPACE ${WORKSPACE}."
bin/dynamicScriptJobBuilder.sh file="${HOME_DIR}/${FILE}"
