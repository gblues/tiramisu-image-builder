#!/usr/bin/env bash

github='https://github.com'
project=$1
output_file=$2

if [ -z "$output_file" ] || [ -z "$project" ]; then
  echo "usage: $(basename $0) <project> <output filename>"
  echo "<project> follows the form '<github_user>/<github_repo>'"
  exit 1
fi

latest_release=$(curl \
  -s \
  --location $github/$project/releases/latest \
  | htmlq --attribute href 'a' \
  | grep '/tag/')

asset_link=$(curl \
  -s \
  ${github}${latest_release} \
 | htmlq --attribute src 'include-fragment' \
 | grep 'https')

download_url=${github}$(curl -s $asset_link | htmlq --attribute href 'a' | grep -v 'archive/refs/tags')

curl -s --location -o "$output_file" "$download_url"
