#!/bin/bash
IFS=$'\n'
for i in $(ls *.mp4); do ~/mt "$i"; done
for i in $(ls *.avi); do ~/mt "$i"; done
for i in $(ls *.webm); do ~/mt "$i"; done
for i in $(ls *.mkv); do ~/mt "$i"; done
unset IFS