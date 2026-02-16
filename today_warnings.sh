#!/bin/bash
#
# --------- Default values -------------
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=5

# ---------- Help ------------
#
usage () {
	echo "Use: $N [-n broj linija] [-f log file] [-h]"
	echo " -n N last N WARNING lines for today (default: 5)"
	echo " -f FILE path to log file (Default: /opt/netzwert/log/CentralError.log)"
	echo " -h	show help"
}

# ------------- Parsing CLI options ---------------
#
while getopts ":n:f:h" opt; do
	case "$opt" in
		n) N="$OPTARG" ;;
		f) LOGFILE="$OPTARG" ;;
		h) usage; exit 1 ;;
		\?) echo "Unknow option: -$OPTARG"; usage; exit 1 ;;
		:) echo "Option -$OPTARG needs argument"; usage; exit 1 ;;
	esac
done

#------------ Check file -----------
#
if [ ! -f "$LOGFILE" ]; then
	echo "Error: file does not exits: $LOGFILE"
	exit 1
fi

# ------------ Main logic - today's date ------------
#
TODAY=$(date +%Y%m%d)

echo "Log: $LOGFILE"
echo "Today's date: $TODAY"
echo "Last N lines from today"
echo "========================="

grep -i "warning" "$LOGFILE" | grep "$TODAY" | tail -n "$N"
