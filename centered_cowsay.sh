#!/bin/bash

# Get terminal width
width=$(tput cols)

# Get cowsay output from all passed arguments
output=$(cowsay "$@")

# Calculate the length of the longest line
max_length=$(echo "$output" | wc -L)

# Calculate padding
padding=$(((width - max_length) / 2))

# Print each line of cowsay output with the padding
echo "$output" | while IFS= read -r line; do
	printf "%${padding}s%s\n" "" "$line"
done
