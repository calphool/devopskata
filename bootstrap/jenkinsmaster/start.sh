#!/usr/bin/env bash


function installTerraform() {

    if [[ -e ./terraform ]]; then
        echo "Terraform already installed, skipping download."
        return 0
    fi

CURRENT_TF=$(wget --quiet -O -  https://releases.hashicorp.com/terraform/ | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | cut -c2- | sed -n -e '/^terraform/p' | sed -e '/-rc/d' | sort | tail -n1)

if [[ $CURRENT_TF == terraform* ]]; then
   echo "Current version of terraform=$CURRENT_TF"
else
   echo "Unable to determine current version of terraform"
   exit 2
fi

HASHI_URL=https://releases.hashicorp.com/$CURRENT_TF


if [ "$(uname)" == "Darwin" ]; then
    # Download OSX version
    FILEPATH=$(wget --quiet -O - $HASHI_URL | grep -o 'href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | cut -c8- | sed -n -e '/.zip/p' | sort | sed -n -e '/darwin_amd/p')
    FILEPATH2=$(echo $FILEPATH | rev | cut -f1 -d"/" | rev)
    FULLURL=$HASHI_URL$FILEPATH2
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Download Linux AMD64 version
    sudo yum -y install unzip
    FILEPATH=$(wget --quiet -O - $HASHI_URL | grep -o 'href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | cut -c8- | sed -n -e '/.zip/p' | sort | sed -n -e '/linux_amd/p')
    FILEPATH2=$(echo $FILEPATH | rev | cut -f1 -d"/" | rev)
    FULLURL=$HASHI_URL$FILEPATH2
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "We don't serve your kind here."
    exit 1
fi


    if [[ -e terraform.zip ]]; then
        echo "terraform.zip already exists."
    else
        echo "Downloading: $FULLURL"
        rm terraform* 2> /dev/null
        rm terraform.* 2> /dev/null
        wget --quiet -O terraform.zip $FULLURL
    fi

    unzip terraform.zip
}


installTerraform

cp buildEC2.tf buildEC2.bak

sed -i '' "s/INGRESSBLOCK/$(echo $TF_VAR_ThisNodeProviderCIDR | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
terraform apply
mv buildEC2.bak buildEC2.tf

