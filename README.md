# Command Line Interface for Boomi CI/CD

The CLI utility wraps calls to [Boomi Atomsphere APIs](https://help.boomi.com/bundle/integration/page/r-atm-AtomSphere_API_6730e8e4-b2db-4e94-a653-82ae1d05c78e.html). Handles input and output JSON files and performance orchestration for deploying and managing Boomi runtimes, components and metadata required for CI/CD.
  
## Pre-requistes
  - The CLI utility currently runs on any Linux OS and invokes BASH shell scripts
  - The CLI utility requires jq - JSON Query interpreter installed 
  
        # Using yum #
        $ yum install -y jq 
        ## Using apt
        $ apt-get install -y jq 

## Set up
- 
        $ SCRIPTS_HOME='/pathto/scripts'
        $ cd $SCRIPTS_HOME
        $ export accountId=company_account_uuid
        $ export authToken=BOOMI_TOKEN.username@company.com:aP1k3y02-mob1-b00M-M0b1-at0msph3r3aa
        $ export h1="Content-Type: application/json"
        $ export h2="Accept: application/json"
        $ export baseURL=https://api.boomi.com/api/rest/v1/$accountId
        $ export WORKSPACE=`pwd`
        
## Run your first script
- 
        $ source bin/publishAtom.sh > index.html
    
## List of Interface

The followings script/ calls a single API

| **SCRIPT_NAME** | **ARGUMENTS** | **JSON FILE** |**API/Action**| **Notes**|
| ------ | ------ | ------ | ------ | ------ |

The following scripts perform orchestration by calling multiple APIs
| **SCRIPT_NAME** | **ARGUMENTS** | **JSON FILE** |**API/Action**| **Notes**|
| ------ | ------ | ------ | ------ | ------ |

The following scripts publish html reports
| **SCRIPT_NAME** | **ARGUMENTS** | **JSON FILE** |**API/Action**| **Notes**|
| ------ | ------ | ------ | ------ | ------ |


The following scripts installs Boomi runtime
| **SCRIPT_NAME** | **ARGUMENTS** | **JSON FILE** |**API/Action**| **Notes**|
| ------ | ------ | ------ | ------ | ------ |

## common. sh


