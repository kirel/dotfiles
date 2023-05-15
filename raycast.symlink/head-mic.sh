#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Headphones and USB Microphone
# @raycast.mode silent
# @raycast.icon 🎧

source ~/.profile

switchaudiosource -s "Arctis Nova 7"
switchaudiosource -s "Arctis Nova 7" -t system
switchaudiosource -s "Razer Seiren Mini" -t input