#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Headphones and Mac Microphone
# @raycast.mode silent
# @raycast.icon 🎧

# Source the helper script relative to the current script's directory
source "$(dirname "$0")/.raycast.symlink/.helper.sh"

# Get MacBook mic name dynamically
MAC_MIC_NAME=$(get_audio_device_name "MacBook Pro" "Microphone|Mikrofon")

# Check if mic name was found
if [[ -z "$MAC_MIC_NAME" ]]; then
    echo "Error: Could not find MacBook Pro Microphone." >&2
    exit 1
fi

# Use fixed name for headphones
HEADPHONES_NAME="Arctis Nova 7"

# Switch audio devices
switchaudiosource -s "$HEADPHONES_NAME"
switchaudiosource -s "$MAC_MIC_NAME" -t input
switchaudiosource -s "$HEADPHONES_NAME" -t system