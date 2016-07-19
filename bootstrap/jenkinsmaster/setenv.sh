#!/usr/bin/env bash

installBrew() {
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 2> /dev/null
}

installwget() {
brew install wget
}

installPython() {
brew install python
}

installAWSCli() {
pip install -q awscli
}

checkForCredentials() {
    echo "Checking for credentials..."
    sCredentialsPath=""
    sPemPath=""
    for i in `find /Volumes -type d -maxdepth 1 -mindepth 1`; do
        if [[ -f "$i/aws_credentials.csv" ]]; then
            sCredentialsPath=$i/aws_credentials.csv
            if [[ -f "$i/devops_1.pem" ]]; then
                sPemPath=$i/devops_1.pem
            fi
        fi
    done;

    if [ -z ${sCredentialsPath+x} ]; then
        echo "Credentials file not found."
        exit 1
    fi

    if [ -z ${sPemPath+x} ]; then
        echo "Pem file not found."
        exit 2
    fi

    echo "Located AWS credentials and PEM file"
}

validateAWSSetup() {
    if [[ -z "$AWS_CONFIG_FILE" ]] ; then 
        echo "AWS_CONFIG_FILE not set."
        exit 3
    fi

    if [[ -z "$AWS_DEFAULT_REGION" ]] ; then
        echo "AWS_DEFAULT_REGION not set."
        exit 4
    fi

    if [[ -z "$AWS_PROFILE" ]] ; then
        expt "AWS_PROFILE not set."
        exit 5
    fi
}



if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] ; then
    echo "Format:  source ./setenv.sh <github-repo-name> <github-userid> <pem file path>"
else
#   checkForCredentials
    validateAWSSetup
    installBrew
    installwget
    installPython
    installAWSCli
    export TF_VAR_ThisNodeExternalIP=$(wget http://ipinfo.io/ip -qO -)
    export TF_VAR_ThisNodeProviderCIDR=$(whois -h whois.arin.net "$TF_VAR_ThisNodeExternalIP" | grep -F "CIDR:" | cut -c17-)
    export TF_VAR_github_reponame=$1
    export TF_VAR_github_user=$2
    export TF_LOG=TRACE
    export TF_LOG_PATH=./tflog.txt
    echo "External IP address: $TF_VAR_ThisNodeExternalIP"
    eval $(source ./setCredentialsScript.sh "$1" "$sCredentialsPath" "$3" "$TF_VAR_ThisNodeExternalIP")
fi
