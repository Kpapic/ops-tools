#!/bin/bash
#
# Script for checking WARNING message from the log file
#
LOGFILE="${1:-/opt/netzwert/log/CentralError.log}"
N=${2:-5}

# Check if the given path is a log file
#
if [ -d "$LOGFILE" ]; then
	echo "Error: given path is a directory"
	exit 0
fi

if [ ! -f "$LOGFILE" ]; then
	echo "Error: given path is not a log file: $LOGFILE"
	exit 0
fi

echo "The warning N lines from the Log file: $LOGFILE"

grep -i "warning" "$LOGFILE" | tail -"$N"
