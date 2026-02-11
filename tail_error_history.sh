#!/bin/bash

# Use:
# ./tail_error_history.sh	# use default log
# ./tail.error_history.sh /path/log	# use different log
#
LOGFILE="${1:-/opt/netzwert/log/CentralError.log}"
N=${2:-5}

# Check if the file exists
echo
if [ -d "$LOGFILE" ]; then
	echo "Error: path is a directory - expected file"
	exit 0
fi

if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file doesn't exists: $LOGFILE"
	exit 0
fi

echo
echo "Logfile: $LOGFILE"
echo "Last N error lines"
echo "===================="

grep -i "error" "$LOGFILE" | tail -"$N"


