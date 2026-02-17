#!/bin/bash
# -------------- Default values --------------
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=5

# ------------ Help function ---------------
#
usage() {
	echo "Use $0 [-n number lines] [-f log file] [-h]"
	echo " -n N Last N ERROR lines for today (default: 5)"
	echo " -f FILE	path to log file (Default:/opt/netzwert/log/CentralError.log)"
	echo " -h	show help"
}

# ------------- Long option -----------------
#
for arg in "$@"; do
	case "$arg" in
		--help) usage; exit 0 ;;
		--file) shift; LOGFILE="$1"; shift ;;
		--number) shift; N="$1"; shift ;;
	esac
done

# --------------- Parsing short options --------------------
#
while getopts ":n:f:h" opt; do
	case "$opt" in
		n) N="$OPTARG" ;;
		f) LOGFILE="$OPTARG" ;;
		h) usage; exit 0 ;;
		\?) echo "Unknown option: -$OPTARG"; usage; exit 1 ;;
		:) echo " Option -$OPTARG requires and argument"; usage; exit 1 ;;
	esac
done

# ------------- Checking log file ----------------
#
if [ ! -f "$LOGFILE" ]; then
	echo "Error: file does not exists: $LOGFILE"
	exit 1
fi

# ----------- Two format date -------------
#
TODAY_YMD=$(date +%Y%m%d)
TODAY_SYS=$(date "+%b %e")

echo "Logfile: $LOGFILE"
echo "Today's date: $TODAY_YMD"
echo " Last $N ERROR lines for today"
echo "============================="

grep -i "error" "$LOGFILE" | grep -E "$TODAY_YMD|$TODAY_SYS" | tail -n $N

