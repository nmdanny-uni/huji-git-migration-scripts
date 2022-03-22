#!/bin/bash

[ -z "$HUJI_TOKEN" ] && echo "Must specify HUJI CSE-Github access token under HUJI_TOKEN" && exit 1

URLS=$(curl -H "Authorization: token $HUJI_TOKEN" "https://github.cs.huji.ac.il/api/v3/user/repos?page=1&per_page=100&visibility=all&affiliation=owner" \
    | jq ". | map(.ssh_url)")

echo "Importing the following repositories: $URLS"

mkdir repos
(cd repos; echo $URLS | jq -r ".[]" | xargs -L1 git clone)

