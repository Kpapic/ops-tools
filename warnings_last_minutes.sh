#!/bin/bash
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=10
M=60

usage() {

echo "Use: $0 [-f log_file] [-n number] [-m minutes] [-h]"
    echo "  -f FILE      path to log file (default: $LOGFILE)"
    echo "  -n N         last N lines (default: $N)"
    echo "  -m MIN       time window in minutes back (default: $M)"
    echo "  -h           show help"
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


# Short options (getops)
#
while getopts ":f:n:m:h" opt; do
	case "$opt" in
		f) LOGFILE="$OPTARG" ;;
		n) N="$OPTARG" ;;
		m) M="$OPTARG" ;;
		h) usage;  exit 0 ;;
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

# N and M validation
#
case "$N" in
	''|*[!0-9]*|0)
		echo "Error: -n / --number must be a postive integer (got '$N')"
		exit 1
		;;
esac


case "$M" in
	''|*[!0-9]*|0)
		echo "Error: -m / --minutes must be a positive integer (got '$M')"
		exit 1
		;;
esac

# Checking log file

if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file does not exist: $LOGFILE"
	exit 1
fi

# Time definition
#
NOW_SYS=$(date "+%b %e %H:%M")
PAST_SYS=$(date -d "$M minutes ago" "+%b %e %H:%M")

NOW_NW=$(date "+%Y%m%d:%H%M")
PAST_NW=$(date -d "$M minutes ago" "+%Y%m%d:%H%M")



# HEADER
############################################
echo "Log: $LOGFILE"
echo "Window: last $M minute(s)"
echo "Anchors: $PAST_SYS .. $NOW_SYS"
echo "Last $N WARNING lines in window"
echo "==============================================="

# AWK
#
results="$(
awk '
BEGIN {
IGNORECASE = 1
FS = "[[:space:]]+"
}
/warning/ {
rest = ""
for (i=6; i <= NF; i++) {
	rest = rest (i==6 ? "" : " ") $i
}
print $1, $2, $3, "--", $5, "--", rest
}
' "$LOGFILE" | grep -E "$NOW_SYS|$PAST_SYS|$NOW_NW|$PAST_NW"
)"

if [ -z "$results" ]; then
	echo "No WARNING lines found in the last $M minute(s)"
	exit 0
	fi

printf "%s\n" "$results" | tail -n "$N"

		
