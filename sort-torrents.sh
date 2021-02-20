#!/bin/bash
set -x
for x in *.mkv.torrent; do
        mv "$x" ~/processing2;
        rm "$(echo ${x%%.*})"*;
done

for x in *.mp4.torrent; do
        mv "$x" ~/processing2;
        rm "$(echo ${x%%.*})"*;
done

for x in *.mov.torrent; do
        mv "$x" ~/processing2;
        rm "$(echo ${x%%.*})"*;
done

for x in *.avi.torrent; do
        mv "$x" ~/processing2;
        rm "$(echo ${x%%.*})"*;
done