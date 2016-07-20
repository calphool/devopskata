echo Code that pushes ./id_rsa.pub to $1, using $2:***** goes here...

keydata=$(cat ./id_rsa.pub)
str1='{"title": "key-$4", "key": "'
str2=$keydata'", "read_only": true }'
str3=$str1$str2
echo $str3 > tmp.txt
curl -H "Content-Type: application/json" -v -X POST -u $2:$3 https://api.github.com/repos/$2/$1/keys --data @tmp.txt
rm tmp.txt 2> /dev/null
