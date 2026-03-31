#!/bin/bash
#
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=10
M=60


usage() {
    echo "Use: $0 [-f logfile] [-n number] [-m minutes] [-h]"
    echo " -f FILE     Path to log file (default: $LOGFILE)"
    echo " -n N        Last N lines (default: $N)"
    echo " -m MIN      Window size in minutes (default: $M)"
    echo " -h          Show help"
    echo
    echo "Long options:"
    echo " --file PATH"
    echo " --number N"
    echo " --minutes MIN"
    echo " --help"
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

while getopts ":f:n:m:h" opt; do
	case "$opt" in
		f) LOGFILE="$OPTARG" ;;
		n) N="$OPTARG" ;;
		m) M="$OPTARG" ;;
		h) usage; exit 0 ;;
		\?) echo "Unknown option: -$OPTARG"; usage; exit 1 ;;
		:) echo "Option -$OPTARG requires an argument"; exit 1 ;;
	esac
done

case "$N" in
	''|*[!0-9]*|0)
		echo "Error -n / --number must be positive integer"
		exit 1
		;;
esac

case "$M" in
	''|*[!0-9]*|0)
		echo "Error -m / --minutes must be positive integer"
esac

if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file does not exist: $LOGFILE"
	exit 1
fi

NOW_SYS=$(date "+%b %e %H:%M")
PAST_SYS=$(date -d "$M minutes ago" "+%b %e %H:%M")

NOW_NW=$(date "+%Y%m%d:%H:%M")
PAST_NW=$(date -d "$M minutes ago" "+%Y%m%d:%H:%M")

results="$(
awk '
BEGIN {
IGNORECASE = 1
FS = "[[:space:]]+"
}
/error/ {
print $1, $2, $4
print $5
rest = ""
for (i=6; i<=NF; i++) {
	rest = rest (i == 6 ? "" : " ") $i
}
print rest
print "---------------------"
}
' "$LOGFILE"
)"

if [ -z "$results" ]; then
	echo "No Error lines found in last $M minutes"
else
	echo "$results" | tail -n "$N"
	fi

