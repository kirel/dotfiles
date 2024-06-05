#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Copy FPV Videos
# @raycast.mode fullOutput
#
# Optional parameters:
# @raycast.icon 📹

# Define your list of sd card names
SD_CARDS=("VR03")

# Source and destination folders
SOURCE="/Volumes/"
DESTINATION="/Volumes/Medien/Videos/FPV/Inbox"
# SD_CARD="VR03"
# Loop through each sd card name
for SD_CARD in "${SD_CARDS[@]}"; do
  echo "Copying movies from $SD_CARD..."
  
  # Get the current date in the format YYYY-MM-DD
  DATE=$(date +"%F")

  # Use fd to copy movie files from the current sd card and rename if necessary, prefixing with the current date
  fd -e avi . /Volumes/$SD_CARD -x ffmpeg -y -i {} -c:v copy -c:a aac $DESTINATION/$DATE-{/.}.mp4 && fd -e avi . /Volumes/$SD_CARD -x rm -f {}
  fd -e mp4 -e mov . /Volumes/$SD_CARD -x mv -f {} $DESTINATION/$DATE-{/}
done
