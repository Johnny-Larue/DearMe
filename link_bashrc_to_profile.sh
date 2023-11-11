#!/bin/bash

# Define the path to the .bashrc file
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"
PROFILE="$HOME/.profile"

# Function to append .bashrc sourcing to a file if not already present
append_bashrc() {
    local file=$1
    # Check if .bashrc sourcing is already in the file
    if ! grep -q "source $BASHRC" "$file"; then
        # It's not there, so append the sourcing command to the file
        echo "Appending .bashrc sourcing to $file"
        echo "" >> "$file" # Ensures there is a newline at the end of the file
        echo "# Source .bashrc if it exists" >> "$file"
        echo "if [ -f \"$BASHRC\" ]; then" >> "$file"
        echo "   source \"$BASHRC\"" >> "$file"
        echo "fi" >> "$file"
    else
        echo ".bashrc sourcing is already present in $file"
    fi
}

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
