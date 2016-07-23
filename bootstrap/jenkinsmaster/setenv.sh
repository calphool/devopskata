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
        echo "AWS_CONFIG_FILE not set.  You need to run aws config."
        exit 3
    fi

    if [[ -z "$AWS_DEFAULT_REGION" ]] ; then
        echo "AWS_DEFAULT_REGION not set.  You need to run aws config."
        exit 4
    fi

    if [[ -z "$AWS_PROFILE" ]] ; then
        expt "AWS_PROFILE not set.  You need to run aws config."
        exit 5
    fi
}



echo "Making sure Brew is installed..."
installBrew

echo "Making sure wget is installed..."
installwget

echo "Making sure python is installed..."
installPython

echo "Making sure AWS command line interface is installed..."
installAWSCli

echo "Validating AWS setup..."
validateAWSSetup

echo "Determining this machine's current external IP address..."
export TF_VAR_ThisNodeExternalIP=$(wget http://ipinfo.io/ip -qO -)

echo "Determining this machine's ISP's CIDR block..."
export TF_VAR_ThisNodeProviderCIDR=$(whois -h whois.arin.net "$TF_VAR_ThisNodeExternalIP" | grep -F "CIDR:" | cut -c17-)

echo "Setting Terraform environment variables..."
export TF_LOG=TRACE
export TF_LOG_PATH=./tflog.txt
export TV_VAR_connectionuser=$AWS_PROFILE

echo "[Done!]"
