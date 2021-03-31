#!/bin/bash
# Credit: https://stackoverflow.com/questions/29116212/split-a-folder-into-multiple-subfolders-in-terminal-bash-script/29118145#29118145

dir_size=2500
dir_name="torrents"
n=$((`find . -maxdepth 1 -type f | wc -l`/$dir_size+1))
for i in `seq 1 $n`;
do
    mkdir -p "$dir_name$i";
    find . -maxdepth 1 -type f | head -n $dir_size | xargs -i mv "{}" "$dir_name$i"
done
