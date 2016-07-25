#!/usr/bin/env bash


pathAdd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

function installTerraform() {
    pathAdd ./tf

    if [[ -e ./tf/terraform ]]; then
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


    if [[ -e ./tf/terraform.zip ]]; then
        echo "terraform.zip already exists."
    else
        mkdir -p ./tf
        echo "Downloading: $FULLURL"
        rm ./tf/terraform* 2> /dev/null
        rm ./tf/terraform.* 2> /dev/null
        wget --quiet -O ./tf/terraform.zip $FULLURL
    fi

    unzip ./tf/terraform.zip -d ./tf
}


if [[ -z "$TF_VAR_ThisNodeExternalIP" ]] ; then
	echo "You do not have TF_VAR_ThisNodeExternalIP set.  Make sure to run:  source setenv.sh"
        exit 1
fi

if [[ -z "$TF_VAR_ThisNodeProviderCIDR" ]] ; then
	echo "You do not have TF_VAR_ThisNodeProviderCIDR set.  Make sure to run:  source setenv.sh"
fi


rm *.tf 2> /dev/null
cp buildEC2.tf.template buildEC2.tf

# see if we have a user from a previous run for default
olduser=`cat startuser.prop 2> /dev/null`

echo " "
read  -p Github_Userid[$olduser]: ghUser

# if they just hit enter, set the value to the old user 
if [[ -z "$ghUser" ]]; then
    ghUser=$olduser
else
    echo $ghUser > startuser.prop
fi 

read -s  -p Github_Password: passw


passwe=$(echo $passw | openssl enc -aes-128-cbc -a -salt -pass pass:wtf) 

echo " "

oldrepo=`cat startrepo.prop 2> /dev/null`

read  -p Github_Repo_Name[$oldrepo]: ghRepoName

if [[ -z "$ghRepoName" ]]; then
    ghRepoName=$oldrepo
else
    echo $ghRepoName > startrepo.prop
fi

oldpem=`cat startpem.prop 2> /dev/null`

read  -p PEM_File_Path[$oldpem]: pfPath

if [[ -z "$pfPath" ]]; then
    pfPath=$oldpem
else
    echo $pfPath > startpem.prop
fi

if [[ ! -f $pfPath ]] ; then
    echo $pfPath does not exist.  Rerun this command with a valid PEM file path.
    exit 1
fi

repoExists=$(curl -s -u "$ghUser:$passw" -X GET https://api.github.com/users/$ghUser/repos | python -mjson.tool | grep -E \"name.*$ghRepoName\")

if [[ -z $repoExists ]] ; then
    echo $ghRepoName cannot be found.  Check your repo name, user id, and password
    exit 2
fi




# actual execution starts here
SECONDS=0

snapid=snap-ab0adb44
customdomain=rounceville.com
jenkinsami=ami-35748f54
buildserverami=ami-950ef6f4
targetserverami=ami-5201f933

selfcidr=$(aws ec2 describe-vpcs --query "Vpcs[0].CidrBlock" --output text)
echo " "
sed -i '' "s/SELFCIDRS/$(echo $selfcidr | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/INGRESSBLOCK/$(echo $TF_VAR_ThisNodeProviderCIDR | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/GITHUB_REPONAME/$(echo $ghRepoName | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/GITHUB_USER/$(echo $ghUser | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/GITHUB_PWD/$(echo $passwe | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/CONNECTIONKEYFILE/$(echo $pfPath | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/PERMSNAPID/$(echo $snapid | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/CUSTOMDOMAIN/$(echo $customdomain | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/JENKINSAMI/$(echo $jenkinsami | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/BUILDSERVERAMI/$(echo $buildserverami | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
sed -i '' "s/TARGETSERVERAMI/$(echo $targetserverami | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" buildEC2.tf
cp buildEC2.tf buildEC2.tf.bak
installTerraform
pathAdd ./tf
rm ./id_rsa 2> /dev/null
rm ./id_rsa.pub 2> /dev/null
terraform apply
rm ./id_rsa 2> /dev/null
rm ./id_rsa.pub 2> /dev/null
rm buildEC2.tf

duration=$SECONDS
echo " "
echo "Terraform took: $((duration / 60)) minutes, $((duration % 60)) seconds to build infrastructure."
echo " "

echo You may need to provide your Mac password to update your /etc/hosts file
echo to create *.$customdomain entries
cat /etc/hosts | sudo awk '!/'$customdomain'/' > ~/hosts2 ; sudo mv ~/hosts2 /etc/hosts
cat /etc/hosts | sudo awk '!/jenkins./' > ~/hosts2 ; sudo mv ~/hosts2 /etc/hosts
cat /etc/hosts | sudo awk '!/build./' > ~/hosts2 ; sudo mv ~/hosts2 /etc/hosts
cat /etc/hosts | sudo awk '!/target./' > ~/hosts2 ; sudo mv ~/hosts2 /etc/hosts
sudo sh -c "echo \"$(terraform output jenkinsmaster_public_ip) jenkins.$(echo $customdomain)\" >> /etc/hosts"
sudo sh -c "echo \"$(terraform output buildserver_public_ip) build.$(echo $customdomain)\" >> /etc/hosts"
sudo sh -c "echo \"$(terraform output targetserver_public_ip) target.$(echo $customdomain)\" >> /etc/hosts"
