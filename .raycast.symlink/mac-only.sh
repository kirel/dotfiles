#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Switch Audio to Mac Speakers and Mic
# @raycast.mode silent
# @raycast.icon 💻

# Source the helper script relative to the current script's directory
source "$(dirname "$0")/.raycast.symlink/.helper.sh"

# Get device names dynamically
MAC_SPEAKER_NAME=$(get_audio_device_name "MacBook Pro" "Speaker|Lautsprecher")
MAC_MIC_NAME=$(get_audio_device_name "MacBook Pro" "Microphone|Mikrofon")

# Check if names were found
if [[ -z "$MAC_SPEAKER_NAME" ]]; then
    echo "Error: Could not find MacBook Pro Speakers." >&2
    exit 1
fi
if [[ -z "$MAC_MIC_NAME" ]]; then
    echo "Error: Could not find MacBook Pro Microphone." >&2
    exit 1
fi

# Switch audio devices using the dynamically found names
switchaudiosource -s "$MAC_SPEAKER_NAME"
switchaudiosource -s "$MAC_SPEAKER_NAME" -t system
switchaudiosource -s "$MAC_MIC_NAME" -t input