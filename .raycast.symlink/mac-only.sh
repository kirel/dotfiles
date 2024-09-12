#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Mac Speakers and Mic
# @raycast.mode silent
# @raycast.icon 💻

source ~/.profile

switchaudiosource -s "MacBook Pro-Lautsprecher"
switchaudiosource -s "MacBook Pro-Lautsprecher" -t system
switchaudiosource -s "MacBook Pro-Mikrofon" -t input