#!/bin/bash

[ -z "$GH_TOKEN" ] && echo "Must specify Github access token under GH_TOKEN" && exit 1
[ -z "$GH_ORG" ] && echo "Must specify Github organization name under GH_ORG" && exit 1

upload_to_gh () {
    repo_name=$(basename -- $1)
    echo "Uploading $repo_name at $1"
    response=$(curl --fail -H "Authorization: token $GH_TOKEN" -X POST "https://api.github.com/orgs/$GH_ORG/repos" \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Content-Type: application/json" \
         -d ' { "private": true, "name": "'$repo_name'" }')
    [ $? != 0 ] && echo "exiting due to curl failure" && exit 1
    remote=$(echo $response | jq -r ".ssh_url")
    git -C $1 remote add gh $remote
    git -C $1 push --all gh
}

fdfind . ./repos -E "*bfg-report" --max-depth 1 | while read file; do upload_to_gh $file; done

