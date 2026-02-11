#!/bin/bash
#
# Use:
# ./today_warnings.sh	# default log
# ./today_warning.sh /path/to/log/	# second log
#
LOGFILE="${1:-/opt/netzwert/log/CentralError.log}"
TODAY=$(date +%Y%m%d)

# Check for the directory/file/log file
#
if [ -d "$LOGFILE" ]; then
	echo "Error: the given path is a directory"
	exit 1
fi

if [ ! -f "$LOGFILE" ]; then
	echo "Error: the given path is not a log file: $LOGFILE"
	exit 1
fi

echo "Log: $LOGFILE"
echo "Date: $TODAY"
echo "Today's WARNING messages:"
echo "========================="

# Filtering WARNING message + today's date
grep -i "warning" "$LOGFILE" | grep "$TODAY"
