# Log severity check (ERROR / WARNING)
# Zašto postoji


kripta se koristi kao brzi, ručni alat tijekom telco smjene
za rano prepoznavanje potencijalnih problema (WARNING)
i kritičnih stanja (ERROR) u logovima.

WARNING poruke se tretiraju kao rani indikator
potencijalnih budućih ERROR stanja i pomažu u proaktivnom nadzoru sustava.


## Što radi
- Provjerava postoji li ERROR u log i ispisuje zadnju (ili zadnjih N) ERROR linija
- Provjerava postoji li WARNING u log i ispisuje zadnju (ili zadnjih N) WARNING linija
- Prikazuje ukupan broj ERROR i WARNING zapisa (COUNT)

## Kako se koristi
'''bash
/check_severity_test.sh
/check_severity_test.sh /path/do/loga
/check_severity_test.sh /path/do/loga 5
