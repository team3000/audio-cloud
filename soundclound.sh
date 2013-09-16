#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage: $0 <sound url> <client_id>"
  exit
fi

echo Fetching http://api.soundcloud.com/resolve.json?url=$1"&client_id"=$2;
curl http://api.soundcloud.com/resolve.json?url=$1"&client_id"=$2;

printf "\n\nPlease enter the location url without the client_id:\n";
read location_url
printf "\nYou entered: $location_url"

curl $location_url?client_id=$2;

printf "\n\nPlease enter the stream_url without the client_id:\n";
read stream_url
printf "\nYou entered: $stream_url"

printf "\nTo play a sound use the url -> ";
echo $stream_url?client_id=$2;
#!echo http://api.soundcloud.com/tracks/91121058/stream?client_id=$2;
