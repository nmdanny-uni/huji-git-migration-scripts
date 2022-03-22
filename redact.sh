#!/bin/bash


FILES=$(rg -f ./sensitive.txt -H --files-with-matches ./repos)
REGEX="$(tr '\n' '|' < ./sensitive.txt)DELETED"

echo "Files to be modified: $FILES"
echo "Sensitive data regex: $REGEX"
echo "$FILES" | xargs -I "{}" -d '\n' sed -i -E "s/$REGEX/DELETED/g" {}

fdfind . ./repos/ --maxdepth=1 -x git -C {} add -u
fdfind . ./repos/ --maxdepth=1 -x git -C {} commit -m "remove IDs from plaintext"

java -jar ./bfg-1.14.0.jar 
fdfind ".git\$" -H ./repos -x java -jar ./bfg-1.14.0.jar --replace-text ./sensitive.txt {}
