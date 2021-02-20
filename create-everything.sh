#!/bin/bash
IFS=$'\n'
for i in $(ls); do ~/mktorrent.sh "$i"/*.mp4 .; done
for i in $(ls); do ~/mktorrent.sh "$i"/*.avi .; done
for i in $(ls); do ~/mktorrent.sh "$i"/*.webm .; done
for i in $(ls); do ~/mktorrent.sh "$i"/*.mkv .; done
unset IFS
