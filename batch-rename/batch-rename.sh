#!/bin/bash
set -e
shopt -s globstar

debug=true

path=$1
pattern=$2
iteration=0

list_paths() {
    local folder
    for folder in *;
    do
        [[ ! -d $folder ]] && continue
        if [ $debug = true ]; then
            echo "Entering $folder"
        fi
        cd "$folder"
        list_paths
        list_files
        if [[ "$folder" == *"$pattern"* ]]; then
            if [ $debug = true ]; then
                echo "Folder contains patter!"
            fi
            new_name=$(echo "$folder" | sed "s/$pattern//g")
            if [ $debug = true ]; then
                echo "Folder name will be $new_name"
            else
                if [ $debug = true ]; then
                    echo "Exiting $folder to rename"
                fi
                cd ..
                mv "$folder" "$new_name"
            fi
        else
            if [ $debug = true ]; then
                echo "Exiting $folder"
            fi
            cd ..
        fi
    done
}

list_files() {
    local file
    find * -maxdepth 0 -type f -name '*.*' -print0 | while IFS= read -r -d '' file; do
        if [ $debug = true ]; then
            echo "File found => $file"
        fi
        if [[ "$file" == *"$pattern"* ]]; 
        then
            if [ $debug = true ]; then
                echo "File contains patter!"
            fi
            new_name=$(echo "$file" | sed "s/$pattern//g")
            if [ $debug = true ]; then
                echo "File name will be $new_name"
            else
                mv "$file" "$new_name"
            fi 
        fi
    done
}

if [ -z "$path" ]
  then
    echo "No path supplied"
    exit
fi

if [ -z "$pattern" ]
  then
    echo "No pattern supplied"
    exit
fi

cd $path

list_paths
list_files