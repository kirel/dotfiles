#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Mac Speakers and Mic
# @raycast.mode silent
# @raycast.icon 💻

source ~/.profile

switchaudiosource -s "MacBook Pro Speakers"
switchaudiosource -s "MacBook Pro Speakers" -t system
switchaudiosource -s "MacBook Pro Microphone" -t input