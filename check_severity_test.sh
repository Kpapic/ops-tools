#!/bin/bash


LOGFILE="${1:-/opt/netzwert/log/CentralError.log}"
N="${2:-1}"
echo "Log: $LOGFILE"
echo
echo "----------------------------------------"

if [ -d "$LOGFILE" ]; then
	echo "Greška: Zadani path je direktorij, očekujem datoteku"
	exit 0
fi

if [ ! -f "$LOGFILE" ]; then
	echo "Greška: log datoteka ne postoji: $LOGFILE"
	exit 0
fi

err_count=$(grep -i "error" "$LOGFILE" | wc -l)
war_count=$(grep -i "warning" "$LOGFILE" | wc -l)

echo
echo "Erorr count: $err_count"
echo "Warning count: $war_count"
echo "------------------------------"

if grep -qi "error" "$LOGFILE"; then
	echo "Ima ERROR"
	echo "Zadnja error linija:"
grep -i "error" "$LOGFILE" | tail -"$N"
else
	echo "Nema ERROR-a"
fi

echo

if grep -qi "warning" "$LOGFILE"; then
	echo "Ima WARNING"
	echo "Zadnja WARNING linija:"
grep -i "warning" "$LOGFILE" | tail -"$N"
else
	echo "Nema WARNINGA"
fi


