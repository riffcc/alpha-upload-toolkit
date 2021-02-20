#!/bin/bash
IFS=$'\n'
for i in $(ls); do ~/mt "$i"/*.mp4 .; done
for i in $(ls); do ~/mt "$i"/*.avi .; done
for i in $(ls); do ~/mt "$i"/*.webm .; done
for i in $(ls); do ~/mt "$i"/*.mkv .; done
unset IFS