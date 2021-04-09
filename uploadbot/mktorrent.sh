#!/bin/bash
mktorrent -p -s "Riff.CC" -a https://u.riff.cc/announce/`cat ~/.rcc-api` "${@}"
