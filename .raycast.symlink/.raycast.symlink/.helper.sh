#!/bin/zsh

# Helper functions for Raycast audio switching scripts

# Cache for audio device list to avoid multiple calls per script run
_ALL_AUDIO_DEVICES_CACHE=""

# Function to find an audio device name dynamically
# Usage: get_audio_device_name "Primary Identifier" ["Secondary Identifier Regex"]
# Example: get_audio_device_name "MacBook Pro" "Speaker|Lautsprecher"
# Example: get_audio_device_name "Razer Seiren Mini"
get_audio_device_name() {
    local primary_identifier="$1"
    local secondary_regex="$2"
    local device_list
    local found_name

    # Populate cache if empty
    if [[ -z "$_ALL_AUDIO_DEVICES_CACHE" ]]; then
        # Get all devices, ignore stderr in case command isn't found immediately
        _ALL_AUDIO_DEVICES_CACHE=$(switchaudiosource -a 2>/dev/null)
        # Basic check if command failed or returned nothing
        if [[ -z "$_ALL_AUDIO_DEVICES_CACHE" ]]; then
             echo "Error: switchaudiosource -a failed or returned empty." >&2
             _ALL_AUDIO_DEVICES_CACHE="" # Clear cache on failure
             return 1 # Indicate failure
        fi
    fi

    device_list="$_ALL_AUDIO_DEVICES_CACHE"

    # Filter by primary identifier using grep
    found_name=$(echo "$device_list" | grep "$primary_identifier")

    # Optionally filter by secondary regex if provided
    if [[ -n "$secondary_regex" ]]; then
        # Use grep -E for extended regex (like | for OR)
        found_name=$(echo "$found_name" | grep -E "$secondary_regex")
    fi

    # Return the first match only
    echo "$found_name" | head -n 1

    # Check if anything was found and return appropriate exit code
     if [[ -z "$(echo "$found_name" | head -n 1)" ]]; then
         # Optionally echo an error here, but returning empty might be better for the script
         # echo "Warning: Could not find device matching '$primary_identifier' / '$secondary_regex'" >&2
         return 1 # Indicate failure
     fi
     return 0 # Indicate success
}