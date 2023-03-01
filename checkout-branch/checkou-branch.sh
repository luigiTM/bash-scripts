#!/bin/bash
set -e

checkout_branch=$1

if [ -z "$checkout_branch" ]
  then
    echo "No branch name supplied"
    exit
fi

folders=($(ls -d */))

if [ -z "$folders" ]
  then
    echo "No folders found"
    exit
fi

for i in "${folders[@]}"
do
    echo "Entering $i"
    cd "$i"
    current_branch="$(git branch --show-current)"
    if ["$current_branch" != "$checkout_branch"];
        then
            echo "$i is not at $checkout_branch"
    fi
    cd ..
done

echo "Done!"