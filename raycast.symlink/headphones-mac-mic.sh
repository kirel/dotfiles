#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Headphones and Mac Microphone
# @raycast.mode silent
# @raycast.icon 🎧

source ~/.profile

switchaudiosource -s "Arctis Nova 7"
switchaudiosource -s "MacBook Pro Microphone" -t input
switchaudiosource -s "Arctis Nova 7" -t system