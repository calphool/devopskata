#!/usr/bin/env bash

installBrew() {
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 2> /dev/null
}

installwget() {
brew install wget
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



if [[ -z "$1" ]]; then
    echo "You must provide a valid username that exists in AWS IAM"
    echo "You must also install a flash drive that contains a valid"
    echo ".pem file and aws_credentials.csv file"
else
    checkForCredentials
    installBrew
    installwget
    export TF_VAR_ThisNodeExternalIP=$(wget http://ipinfo.io/ip -qO -)
    echo "External IP address: $TF_VAR_ThisNodeExternalIP"
    ./setCredentialsScript.sh "$1" "$sCredentialsPath" "$sPemPath" "$myExternalIPAddress"
    eval $(source ./setCredentialsScript.sh "$1" "$sCredentialsPath" "$sPemPath" "$TF_VAR_ThisNodeExternalIP")
fi
