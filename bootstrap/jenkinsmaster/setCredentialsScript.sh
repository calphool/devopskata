
echo export TF_VAR_connectionkeyfile="$3"
echo export TF_VAR_connectionuser="$1"


function setCredentialsFor() {
        userName=\"$1\"
        filename="$2"

	while IFS='' read -r line || [[ -n "$line" ]]; do
                if [[ $line == $userName* ]] ; then
                    IFS=', ' read -r -a lineArray <<< "$line"
                    #echo export AWS_ACCESS_KEY_ID=\"${lineArray[1]}\"
                    #echo " "
                    #echo export AWS_SECRET_ACCESS_KEY=\"${lineArray[2]}\"
                    #echo " "
                    #echo export AWS_DEFAULT_REGION=\"ap-northeast-1\"
                    return 0                   
                fi
	done < "$filename"

        if [[ $bCredentialsSet == false ]] ; then
             echo "#Unable to set credentials"
             return -1
        fi
        return 0
}

#don't use this method for setting credentials.  Use the ~/.aws/ approach
#setCredentialsFor "$1" "$2" 
