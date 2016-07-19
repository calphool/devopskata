#!/usr/bin/env bash

if [[ -z "$1" ]] ; then
    echo "You must provide a userid"
    exit 1
fi

if [[ -z "$2" ]] ; then
    echo "You must provide a pwd"
    exit 2
fi

if [[ -z "$3" ]] ; then
    echo "You must provide a repo name"
    exit 3
fi


curl -s -u "$1:$2" -X GET https://api.github.com/repos/$1/$3/hooks | python -mjson.tool | grep -E '\"url.*hooks.*' | cut -c17- | rev | cut -c2- | rev >> ~tmp.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
    curl -s -u "$1:$2" -X DELETE $line
done < ~tmp.txt

rm ~tmp.txt
