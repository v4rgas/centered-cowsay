#!/bin/bash

# Get terminal width
width=$(tput cols)

# Initialize variables
screenshot=false

# Parse flags and arguments
while getopts ":sf:" opt; do
	case $opt in
	s)
		screenshot=true
		;;
	f)
		# Pass the selected cowsay file (e.g. -f dragon)
		cowsay_flag="-f $OPTARG"
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	esac
done

# Shift the parsed flags, leaving only cowsay arguments
shift $((OPTIND - 1))

# Get cowsay output with optional flag support
output=$(cowsay $cowsay_flag "$@")

# Calculate the length of the longest line in the cowsay output
max_length=$(echo "$output" | wc -L)

# Calculate the padding to center the output based on terminal width
padding=$(((width - max_length) / 2))

# Print each line of cowsay output with the calculated padding
echo "$output" | while IFS= read -r line; do
	printf "%${padding}s%s\n" "" "$line"
done

# If the -s flag is provided, take a screenshot of the focused window
if [ "$screenshot" = true ]; then
	sleep 1 # Wait for 1 second to ensure the cowsay output is visible
	maim -i $(bspc query -N -n focused) ~/Pictures/cowsay.png
	echo "Screenshot saved to ~/Pictures/cowsay.png"
fi
