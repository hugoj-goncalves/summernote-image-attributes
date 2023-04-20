#!/bin/bash

function build {
  npm run build
}

function updateVersion {
    echo "New version change: $newVersion"
    oldVersionValue=$(cat package.json | grep version | grep -oP "\d+[^\"]+")
    npm version "$newVersion" --preid=next
    newVersionValue=$(cat package.json | grep version | grep -oP "\d+[^\"]+")
    echo "New version value: $newVersionValue - from $oldVersionValue"
}

newVersion="$1"
if [ -z "$newVersion" ]; then
    newVersion="prerelease"
fi

git status | grep 'nothing to commit'
if [ $? -eq 1 ]; then
    echo 'Commit everything before running update script.';
    exit 1
fi

# git pull origin master
updateVersion
# build || exit 2

git status | grep 'nothing to commit'
if [ $? -eq 1 ]; then
    git add -A && git commit -m "dump release files"
fi
git push

npm config set access public
npm publish --registry https://registry.npmjs.org/
