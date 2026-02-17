#!/bin/bash
#
# Default Values
LOGFILE="/opt/netzwert/log/CentralError.log"
N=10

# Help usage
#
usage() {
echo "Use: $0 [-n number of lines] [-f log file] [-h]"
echo " -n N       last N WARNING lines from last hour (default: 10)"
    echo " -f FILE    path to log file (default: /var/log/messages)"
    echo " -h         show help"
    echo ""
    echo "Long options:"
    echo " --number N    same as -n"
    echo " --file PATH   same as -f"
    echo " --help        same as -h"
}

# Long options (for arg in "$@")
#
for arg in "$@"; do
	case "$arg" in 
		--help)
			usage
			exit 0
			;;

		--file) 
			shift
			LOGFILE="$1"
			shift
			;;

		--number)
			shift
			N="$1"
			shift
			;;
	esac
done

# Short options (getopts)
#
while getopts ":n:f:h" opt; do
	case "$opt" in
		n)
			N="$OPTARG"
			;;
		f)
			LOGFILE="$OPTARG"
			;;
		h)	
			usage
			exit 0
			;;
		\?) 
			echo "Unknown option: -$OPTARG"
			usage
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument"
			usage
			exit 1
			;;
	esac
done

# Does log file exists
#
if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file does not exists: $LOGFILE"
	exit 1
fi

# Last Hour
#
NOW_HOUR=$(date "+%b %e %H")
PAST_HOUR=$(date -d "1 hour ago" "+%b %e %H")

# Main report
#

echo "Logfile: $LOGFILE"
echo "Time window: $PAST_HOUR --> $NOW_HOUR"
echo "Last $N WARNING lines from the last hour:"
echo "============================================"

###############################################

grep -i "warning" "$LOGFILE" | grep -E "$NOW_HOUR|PAST_HOUR" | tail -n "$N"
