#!/bin/sh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Monitor Speakers and Microphone
# @raycast.mode silent
# @raycast.icon 🖥

source ~/.profile

/Users/billie/homebrew/bin/switchaudiosource -s "C34J79x"
/Users/billie/homebrew/bin/switchaudiosource -s "C34J79x" -t system
/Users/billie/homebrew/bin/switchaudiosource -s "Razer Seiren Mini" -t input