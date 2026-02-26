#!/bin/bash
#
#  Deafult values
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=10
M=60

# Usage - help for the user
#
usage () {

echo "Use: $0 [-f log_file] [-n number] [-m minutes] [-h]"
    echo "  -f FILE     path to log file (default: $LOGFILE)"
    echo "  -n N        last N lines (default: $N)"
    echo "  -m MIN      time window in minutes back (default: $M)"
    echo "  -h          show help"
    echo
    echo "Long options:"
    echo "  --file PATH     same as -f"
    echo "  --number N      same as -n"
    echo "  --minutes MIN   same as -m"
    echo "  --help          same as -h"
}

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
		--minutes) 
			shift
			M="$1"
			shift
			;;
		esac
	done

# Short options (getopts)
#
while getopts ":f:n:m:h" opt; do
	case "$opt" in
		f) LOGFILE="$OPTARG" ;;
		n) N="$OPTARG" ;;
		m) M="$OPTARG" ;;
		h) 
			usage
			exit 0
			;;
		\?)
			echo "Unknown option: -$OPTARG"
			exit 1
			;;
		:)
			echo "Error: Option -$OPTARG requires and argument"
			exit 1
			;;
	esac
done

# Number validation
#
case "$N" in
	''|*[!0-9]*|0)
		echo "Error: -n / --number must be a positive integer (got "$N")"
		exit 1
		;;
	esac

case "$M" in
	''|*[!0-9]*|0)
		echo "Error: -m / --minutes must be a positive iteger (got "$M")"
		;;
esac

# Check if file exists
#
if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file does not exists: $LOGFILE"
	exit 1
fi

# Checking time stamps - 2 version - for Syslog and Netwert
NOW_SYS=$(date "+%b %e %H:%M")
PAST_SYS=$(date -d "$M minutes ago" "+%b %e %H:%M")

NOW_NW=$(date "+%Y%m%d:%H%M")
PAST_NW=$(date -d "$M minutes ago" "+%Y%m%d:%H%M")


echo "Log: $LOGFILE"
echo "Window: last $M minute(s)"
echo "Anchors: $PAST_SYS .. $NOW_SYS"
echo "Last $N WARNING lines in window"
echo "==============================================="

results="$(awk 'BEGIN{IGNORECASE=1} /warning/' "$LOGFILE" | grep -E "$NOW_SYS|$PAST_SYS|$NOW_NW|$PAST_NW")"

if [ -z "$results" ]; then
	echo "No WARNINGS found in the last $M minute(s)"
else
	printf "%s\n" "$results" | tail -n "$N"
fi




