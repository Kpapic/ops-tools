#!/bin/bash
# Sažetak: koje komponente najčešće prijavljuju WARNING/ERROR u zadnjih N linija

LOGFILE="${1:-/opt/netzwert/log/CentralError.log}"
N="${2:-500}"

if [ -d "$LOGFILE" ]; then
	echo "Greška: zadnji path je direktorij, očekujem datoteku"
	exit 1
fi

if [ ! -f "$LOGFILE" ]; then
	echo "Greška: log datoteka ne postoji: $LOGFILE"
	exit 1
fi

if ! [[ "$N" =~ ^[0-9]+$ ]]; then
	N=500
fi

echo "Log: $LOGFILE"
echo "Zadnjih linija: $N"
echo "-------------------------"

err_count=$(tail -n "$N" "$LOGFILE" | grep -i "error" | wc -l)
warn_count=$(tail -n "$N" "$LOGFILE" | grep -i "warning" | wc -l)

echo "Error count (zadnjih $N): $err_count"
echo "Warning count (zadnjih $N): $warn_count"



