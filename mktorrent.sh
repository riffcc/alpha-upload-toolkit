#!/bin/bash
mktorrent -p -a https://u.riff.cc/announce/`cat ~/.rcc-api` "${@}" -s "Riff.CC"
