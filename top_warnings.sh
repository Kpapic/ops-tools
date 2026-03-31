#!/bin/bash
#
#
LOGFILE="/opt/netzwert/log/CentralError.log"
N=5


ge() {
    echo "Use: $0 [-f log_file] [-n number] [-h]"
    echo
    echo " -f FILE     Path to log file (default: $LOGFILE)"
    echo " -n N        Show TOP N programs (default: $N)"
    echo " -h          Show help"
    echo
    echo "Long options:"
    echo " --file PATH        Same as -f"
    echo " --number N         Same as -n"
    echo " --help             Show help"
    echo
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
	esac
done

while getopts ":f:n:h" opt; do
	case "$opt" in
		f)LOGFILE="$OPTARG" ;;
		n) N="$OPTARG" ;;
		h) usage; exit 0 ;;
	 	\?) echo "Unknown option: -$OPTARG"; usage; exit 1 ;;
		:) echo "Option -$OPTARG reguires an argument"; exit 1 ;;
	esac
done


case "$N" in
    ''|*[!0-9]*|0)
        echo "Error: -n / --number must be a positive integer"
        exit 1
        ;;
esac

# File must exist
if [ ! -f "$LOGFILE" ]; then
    echo "Error: log file does not exist: $LOGFILE"
    exit 1
fi


results="$(
awk '
BEGIN {
IGNORECASE=1
}
/warning/ {
prog=$5
sub(/:$/, "", prog)
count[prog]++
}
END {
for (p in count) 
	print count[p], p
}
' "$LOGFILE" | sort -nr | head -n "$N"
)"


echo "TOP $N WARNING sources in: $LOGFILE"
echo "-----------------------------------------"
echo "$results"
echo "-----------------------------------------"

