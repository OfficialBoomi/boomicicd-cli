#!/bin/bash

# This set the variables used in Azure DevOps pipeline.

# Mostly constants
export h1="$(h1)"
export h2="$(h2)"
export WORKSPACE=$(pwd)

# Get values from user or parameter store
# The following credentials can be stored in parameter store and retrieved dynamically
# Example to retrieve form an AWS store "$(aws ssm get-parameter --region xx --with-decryption --output text --query Parameter.Value --name /Parameter.name)
export accountName="$(accountName)"
export accountId=$(accountId)
export authToken=$(authToken)
export gitRepoURL="$(gitRepoURL)"
export gitUserName="$(gitUserName)"
export gitUserEmail="$(gitUserEmail)"
export sonarHostURL="$(sonarHostURL)"
export sonarHostToken="$(sonarHostToken)"
export sonarProjectKey="$(sonarProjectKey)"
export gitRepoName="$(gitRepoName)" # Top level folder of the GIT REPO
export sonarRulesFile="$(sonarRulesFile)"

# Keys that can change
export VERBOSE="$(VERBOSE)" # Bash verbose output; set to true only for testing, will slow execution.
export SLEEP_TIMER="$(SLEEP_TIMER)" # Delays curl request to the platform to set the rate under 5 requests/second
export gitOption="$(gitOption)" # This clones the repo; else default is to create a release tag. Check gitPush.sh file
export SONAR_HOST=""  # If sonar scanner is installed locally then will use the local sonar scanner. Check the sonarScanner.sh file

# Derived keys
export baseURL=https://api.boomi.com/api/rest/v1/$accountId
export regressionTestURL="$(regressionTestURL)" # URL for regression test suite framework.
echo "Base URL is ${baseURL}"
