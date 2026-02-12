#!/bin/bash

# Default value
N=5
LOGFILE"/opt/netzwert/log/CentralError.log"

usage () {
	echo " Use: $0 [-n broj_linija] [-f log_file] [-h]"
	echo " -n N	broj zadnjih ERROR linija (default: 5)"
	echo " -f FILE	put do log datoteke (default: /opt/netzwert/log/CentralError.log)"
	echo " -h	prikaži pomoć"
}

# CLI opcije

while getopts ":n:f:h" opt; do
	case "$opt" in
		n) N="$OPTARG" ;;	# vrijednost iza -n
		f) LOGFILE="$OPTARG" ;; 	# vrijednost iza -f
		h) usage; exit 0 ;;
		\?) echo "Nepoznata opcija: -$OPTARG"; usage; exit 1 ;;
		:) echo "Opcija -$OPTARG zahtijev vrijednost"; usage; exit 1 ;;
	esac
done

# Provjera datoteke

if [ ! -f "$LOGFILE" ]; then
	echo "Greška: log datoteka ne postoji: $LOGFILE"
	exit 1
fi

echo "Logfile: $LOGFILE"
echo "zadnjih $N ERROR linija"
echo "==========================="

grep -i "error" "$LOGFILE" | tail -n "$N"

