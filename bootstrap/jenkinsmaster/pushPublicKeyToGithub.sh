echo Code that pushes ./id_rsa.pub to $1, using $2:***** goes here...

keydata=$(cat ./id_rsa.pub)
str1='{"title": "ec2key", "key": "'
str2=$keydata'", "read_only": true }'
str3=$str1$str2
str4=\'$str3\'
curl -X POST -u "$2:$3" https://api.github.com/repos/calphool/devopskata_ci_repo/keys --data $str4
