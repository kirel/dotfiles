#!/bin/sh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Headphone
# @raycast.mode silent
# @raycast.icon 🎧

source ~/.profile

switchaudiosource -s "Arctis 7P+"
switchaudiosource -s "Arctis 7P+" -t input
switchaudiosource -s "Arctis 7P+" -t system