#!/bin/bash
IFS=$'\n'
for i in $(ls *.mp4); do ~/mktorrent.sh "$i"; done
for i in $(ls *.avi); do ~/mktorrent.sh "$i"; done
for i in $(ls *.webm); do ~/mktorrent.sh "$i"; done
for i in $(ls *.mkv); do ~/mktorrent.sh "$i"; done
unset IFS
