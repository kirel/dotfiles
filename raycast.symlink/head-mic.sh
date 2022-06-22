#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Headphone and Microphone
# @raycast.mode silent
# @raycast.icon 🎧

source ~/.profile

switchaudiosource -s "Arctis 7P+"
switchaudiosource -s "Arctis 7P+" -t system
switchaudiosource -s "Razer Seiren Mini" -t input