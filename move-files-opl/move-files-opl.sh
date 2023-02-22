#!/bin/bash

if [ -z "$1" ]
  then
    echo "No mount device supplied"
fi

folders=( POPS CD DVD )

if mountpoint -q /mnt; then
    echo "/mnt already in use"
    echo "unmounting"
    sudo umount /mnt
    echo "mounting $1"
    sudo mount $1 /mnt
else
    echo "/mnt not in use"
    echo "mounting $1"
    sudo mount $1 /mnt
fi

for i in "${folders[@]}"
do
    SRC="/mnt/$i"
    DEST="/media/opl/$i"
    if [ "$(ls -A $SRC)" ]; then
        echo "Moving $i games"
        cp /mnt/$i/* /media/opl/$i/ --verbose
	else
        echo "$SRC is empty"
	fi
done

echo "Done movings games!"