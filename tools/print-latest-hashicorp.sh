#!/bin/sh
os=linux
arch=amd64
tool=$1

curl --silent https://releases.hashicorp.com/index.json | \
    jq --raw-output ".${tool} | .versions | to_entries | max_by(.key) | .value.builds | .[] | \
    select(.arch==\"${arch}\") | \
    select(.os==\"${os}\")"
