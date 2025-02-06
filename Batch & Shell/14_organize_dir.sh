#!/bin/bash
# Created 19.09.2021

DOWNLOADS_DIR="$HOME/Downloads"
ORGANIZED_DIR="$HOME/OrganizedDownloads"

# Create directories
mkdir -p "$ORGANIZED_DIR"/{Images,Documents,Videos,Music,Archives,Others}

# Move files to respective folders
find "$DOWNLOADS_DIR" -type f | while read FILE; do
    case "$FILE" in
        *.jpg|*.png|*.gif|*.jpeg) mv "$FILE" "$ORGANIZED_DIR/Images/" ;;
        *.pdf|*.docx|*.txt) mv "$FILE" "$ORGANIZED_DIR/Documents/" ;;
        *.mp4|*.mkv|*.avi) mv "$FILE" "$ORGANIZED_DIR/Videos/" ;;
        *.mp3|*.wav|*.flac) mv "$FILE" "$ORGANIZED_DIR/Music/" ;;
        *.zip|*.tar.gz|*.rar) mv "$FILE" "$ORGANIZED_DIR/Archives/" ;;
        *) mv "$FILE" "$ORGANIZED_DIR/Others/" ;;
    esac
done

echo "Files organized successfully."
