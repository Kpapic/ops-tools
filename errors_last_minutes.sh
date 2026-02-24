#!/bin/bash
#
# Showing last N lines in the last M minutes
# Default value for the log file
# It can be chnages with -f or --file arguments
LOGFILE="/opt/netzwert/log/CentralError.log"

N=10
M=60

# Usage function - showing how the help option is used
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

# Parsing long options
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
		--minutes)
			shift
			M="$1"
			shift
			;;
		esac
	done

# Short Options
#
while getopts ":f:n:m:h" opt; do
	case "$opt" in
		f) LOGFILE="$OPTARG" ;;
		n) N="$OPTARG" ;;
		m) M="$OPTARG" ;;
		h) usage; exit 0 ;;

		\?)
			echo "Unknown option: -$OPTARG"
			usage
			exit 1 
			;;
		:)
			echo "Option: -$OPTARG requires an argument"
			usage
			exit 1
			;;
		esac
	done


case "$N" in
	''|*[!0-9]*|0)
		echo "Error: -n / --number must be a positive interger: $N"
		exit 1
		;;
esac

case "$M" in
	''|*[!0-9]*|0)
		echo "Error: -m / --minutes must be a positive interger: $M"
		exit 1
		;;
esac

# Checking log file
#
if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file does not exists: $LOGFILE"
	exit 1
fi

# Time frame
#
NOW_SYS=$(date "+%b %e %H:%m")
PAST_SYS=&(date -d "$M minutes ago" "+%b %e %H:%m")

NOW_NW=$(date "+%Y%m%d:%H%m")
PAST_NW=$(date -d "$M minutes ago" "+%Y%m%d:%H:%m")


echo "Logfile: $LOGFILE"
echo "Window: last $M minutes"
echo "Anchors: $PAST_SYS .. $NOW_SYS"
echo "Last $N ERROR lines in window"
echo "================================="

results="$(grep -i "error" "$LOGFILE" | grep -E "$NOW_SYS|$PAST_SYS|$NOW_NW|$PAST_NW")"

if [ -z "$results" ]; then
	echo "No error lines found in the last $M minutes"
else
	printf "%s\n" "$results" | tail -n "$N"
fi

