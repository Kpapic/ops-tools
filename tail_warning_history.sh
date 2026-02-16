#!/bin/bash
# ------------ Default settings ---------------
#
N=5
LOGFILE="/opt/netzwert/log/CentralError.log"

# -------------- Help ----------------
#
usage() {
	echo "Use: $0 [-n number of lines] [-f log_file] [-h]"
	echo " -n N number of last WARNING lines (default: 5)"
	echo " -f FILE path to log file (default:/opt/netzwert/log/CentralError.log)"
	echo " -h show help"

}

# ------- Parsing ----------------
#
while getopts ":n:f:h:" opt; do
	case "$opt" in
		n) N="$OPTARG" ;;
		f) LOGFILE="$OPTARG" ;;
		h) usage; exit 0 ;;
		\?) echo "Unknown option: -$OPTARG"; usage; exit 1 ;;
		:) echo "Option -$OPTARG needs argument"; usage; exit 1 ;;
	esac
done


# ----------------- Basic log file check -----------------
#
if [ ! -f "$LOGFILE" ]; then
	echo "Error: log file doesn't exists: $LOGFILE"
	exit 1
fi

# ------------ Report ---------------
#
#
echo "Log: $LOGFILE"
echo "Last $N WARNING lines"
echo "======================"

grep -i "warning" "$LOGFILE" | tail -n "$N"

