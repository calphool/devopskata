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


validateAWSSetup
installBrew
installwget
installPython
installAWSCli
export TF_VAR_ThisNodeExternalIP=$(wget http://ipinfo.io/ip -qO -)
export TF_VAR_ThisNodeProviderCIDR=$(whois -h whois.arin.net "$TF_VAR_ThisNodeExternalIP" | grep -F "CIDR:" | cut -c17-)
export TF_LOG=TRACE
export TF_LOG_PATH=./tflog.txt
export TV_VAR_connectionuser=$AWS_PROFILE
echo "External IP address: $TF_VAR_ThisNodeExternalIP"

