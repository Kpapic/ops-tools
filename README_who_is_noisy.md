
## Alat: who_is_noisy.sh

Broji ERROR i WARNING unutar zadnjih N linija loga (svježi signal).
Koristi `tail + grep + wc -l`; bez automatizacije, za ručni uvid.

**Upotreba:**
```bash
./recent_severity_count.sh                 # default log, N=500
./recent_severity_count.sh /path/to/log    # drugi log, N=500
./recent_severity_count.sh /path/to/log 800

