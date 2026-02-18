#!/bin/bash
#
# ---------------- Default values -------------
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=10
M=60


usage () {

    echo "Use: $0 [-f log_file] [-n number] [-m minutes] [-h]"
    echo " -f FILE     path to log file (default: /var/log/messages)"
    echo " -n N        last N lines (default: 10)"
    echo " -m MIN      time window in minutes back (default: 60)"
    echo " -h          show help"
    echo ""
    echo "Long options:"
    echo " --file PATH     same as -f"
    echo " --number N      same as -n"
    echo " --minutes MIN   same as -m"
    echo " --help          same as -h"
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

while getopts  ":f:n:m:h" opt; do
	case "$opt" in
		f)
			LOGFILE="$OPTARG"
			;;
		n)
			N="$OPTARG"
			;;
		m)
			M="$OPTARG"
			;;
		h)
			usage
			exit 0
			;;

		\?)
			echo "Unknown short option:  -$OPTARG"
			exit 1
			;;
		:) 
			echo "Option $OPTARG requires an argument"
			exit 1
			;;
	esac
done


# ------------ Checking log file ------------------
#
if [ ! -f "$LOGFILE" ]; then
	echo "Error: Log file does not exists: $LOGFILE"
	exit 1
fi

NOW_SYS=$(date "+%b %e %H:%M")
PAST_SYS=$(date -d "$M minutes ago" "+%b %e %H:%M")

NOW_NW=$(date "+%Y%m%d:%H%M")
PAST_NW=$(date -d "$M minutes ago" "+%Y%m%d:%H%M")

grep -i "error" "$LOGFILE" | grep -E "$NOW_SYS|$PAST_SYS|$NOW_NW|$PAST_NW" | tail -n "$N"

