#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Mac Speakers and USB Microphone
# @raycast.mode silent
# @raycast.icon 💻

source ~/.profile

switchaudiosource -s "MacBook Pro Speakers"
switchaudiosource -s "MacBook Pro Speakers" -t system
switchaudiosource -s "Razer Seiren Mini" -t input