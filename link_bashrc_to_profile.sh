#!/bin/bash

# Function to create a backup of a file with a timestamp
backup_file() {
    local file=$1
    local timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
    local backup="${file}.backup.${timestamp}"
    if cp "$file" "$backup"; then
        echo "Backup of $file created at $backup."
    else
        echo "Failed to create a backup of $file."
        exit 1
    fi
}

# Function to append .bashrc sourcing to a file if not already present
append_bashrc() {
    local file=$1
    local current_date=$(date +"%Y-%m-%d")
    local comment="Added by Darren B on $current_date, from https://raw.githubusercontent.com/Johnny-Larue/DearMe/main/link_bashrc_to_profile.sh"
    # Check if .bashrc sourcing is already in the file
    if ! grep -q 'source \$HOME/.bashrc' "$file"; then
        # Backup the original file before modifying
        backup_file "$file"
        # It's not there, so append the sourcing command to the file
        echo "Appending .bashrc sourcing to $file"
        echo "" >> "$file" # Ensures there is a newline at the end of the file
        echo "# $comment" >> "$file"
        echo "# Source .bashrc if it exists" >> "$file"
        echo "if [ -f \"\$HOME/.bashrc\" ]; then" >> "$file"
        echo "   source \"\$HOME/.bashrc\"" >> "$file"
        echo "fi" >> "$file"
    else
        echo ".bashrc sourcing is already present in $file"
    fi
}

# Define the paths to the files
BASH_PROFILE="$HOME/.bash_profile"
PROFILE="$HOME/.profile"

# Check if .bash_profile exists, if so use it; otherwise, use .profile
if [[ -f "$BASH_PROFILE" ]]; then
    append_bashrc "$BASH_PROFILE"
elif [[ -f "$PROFILE" ]]; then
    append_bashrc "$PROFILE"
else
    echo "Neither .bash_profile nor .profile exist in $HOME."
    exit 1
fi

exit 0
