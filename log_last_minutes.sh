#!/bin/bash
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=10
M=60

MODE=""


usage() {
    echo "Use: $0 [--warnings | --errors | --both] [-f logfile] [-n number] [-m minutes]"
    echo
    echo " -f FILE       Path to log file (default: $LOGFILE)"
    echo " -n N          Last N lines (default: $N)"
    echo " -m MIN        Time window in minutes (default: $M)"
    echo " -h            Show help"
    echo
    echo "Long options:"
    echo " --file PATH"
    echo " --number N"
    echo " --minutes MIN"
    echo " --warnings"
    echo " --errors"
    echo " --both"
    echo " --help"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            usage
            exit 0
            ;;

        --warnings)
            MODE="warnings"
            shift
            ;;

        --errors)
            MODE="errors"
            shift
            ;;

        --both)
            MODE="both"
            shift
            ;;

        --file)
            LOGFILE="$2"
            shift 2
            ;;

        --number)
            N="$2"
            shift 2
            ;;

        --minutes)
            M="$2"
            shift 2
            ;;

        *)
            break
            ;;
    esac
done

while getopts ":f:n:m:h" opt; do
	case "$opt" in
		h) usage; exit 0 ;;
		f) LOGFILE="$OPTARG" ;;
		n) N="$OPTARG" ;;
		m) M="$OPTARG" ;;
		\?) echo "Unknown option: -$OPTARG"; usage; exit 1 ;;
		:) echo "Option -$OPTARG requires an argument"; exit 1 ;;
	esac
done

case "$N" in
	''|*[!0-9]*|0)
		echo "Error: -n / --number must be positive integer"
		exit 1
		;;
esac

case "$M" in
	''|*[!0-9]*|0)
		echo "Error: -m / --minutes must be positive integer"
		exit 1
		;;
esac

if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file does not exists: $LOGFILE"
	exit 1
fi

if [ -z "$MODE" ]; then
	echo "Error: you must choose --warnings, --errors or --both"
	exit 1
	fi


NOW_SYS=$(date "+%b %e %H:%M")
PAST_SYS=$(date -d "$M minutes ago" "+%b %e %H:%M")

NOW_NW=$(date "+%Y%m%d:%H:%M")
PAST_NW=$(date -d "$M minutes ago" "+%Y%m%d:%H:%M")

filter_pattern=""
if [ "$MODE" = "warnings" ]; then
	filter_pattern="warning"
elif [ "$MODE" = "error" ]; then
	filter_pattern="error"
else
	filter_pattern="error|warning"
fi

results="$(
awk -v pattern="$filter_pattern" '
BEGIN {
IGNORECASE = 1
FS = "[[:space:]]+"
}
$0 ~ pattern {
print $1, $2, $3
print $5
rest = ""
for (i=6;i<=NF;i++) {
	rest = rest (i == 6 ? "" : " ") $i
}
print rest
print "-------------------"
}
' "$LOGFILE"
)"

if [ -z "$results" ]; then
	echo "No matching ERROR/WARNING lines found in last $M minutes."
else
	echo "$results" | tail -n "$N"
	fi

