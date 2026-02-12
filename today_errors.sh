#!/bin/bash
#
# Use:
# ./today_errors.sh	# default log
# ./today_errors.sh /path/log	# second log
#
LOGFILE="${1:-/opt/netzwert/log/CentralError.log}"
TODAY=$(date +%Y%m%d)

# Checks
#
if [ -d "$LOGFILE" ]; then
	echo "Error: path is a directory, expecting log file"
	exit 1
fi

if [ ! -f "$LOGFILE" ]; then
	echo "Error: path is not a log file: $LOGFILE"
	exit 1
fi

echo "$LOGFILE"
echo "$TODAY"
echo "========================="

error_today_count=$(grep -i -c "$TODAY.*error" "$LOGFILE")

echo "Today's ERROR count: $error_today_count"
echo "==================================="

# Printing ERROR line if any
if [ "$error_today_count" -eq 0 ]; then
	echo "No ERROR messages for today"
else
	grep -i "TODAY.*error" "$LOGFILE"
fi
