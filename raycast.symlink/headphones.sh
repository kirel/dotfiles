#!/bin/sh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Headphones
# @raycast.mode silent
# @raycast.icon 🎧

source ~/.profile

switchaudiosource -s "Arctis Nova 7"
switchaudiosource -s "Arctis Nova 7" -t input
switchaudiosource -s "Arctis Nova 7" -t system