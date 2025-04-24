#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Mac Speakers and USB Microphone
# @raycast.mode silent
# @raycast.icon 💻

# Source the helper script relative to the current script's directory
# Assuming this script is run from the root of the .raycast directory
source "$(dirname "$0")/.raycast.symlink/.helper.sh"

# Get MacBook speaker name dynamically
MAC_SPEAKER_NAME=$(get_audio_device_name "MacBook Pro" "Speaker|Lautsprecher")

# Check if name was found
if [[ -z "$MAC_SPEAKER_NAME" ]]; then
    echo "Error: Could not find MacBook Pro Speakers." >&2
    exit 1
fi

# Use fixed name for Razer mic
RAZER_MIC_NAME="Razer Seiren Mini"

# Switch audio devices
switchaudiosource -s "$MAC_SPEAKER_NAME"
switchaudiosource -s "$MAC_SPEAKER_NAME" -t system
switchaudiosource -s "$RAZER_MIC_NAME" -t input