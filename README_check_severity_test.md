# Log severity check (ERROR / WARNING)

Ova skripta služi za brzu provjeru log datoteka u potrazi za ERROR i WARNING porukama.
Nmajenjena je ručnom korištenju tijekom smjene (human-readable output)

## Što radi
- Provjerava postoji li ERROR u log i ispisuje zadnju (ili zadnjih N) ERROR linija
- Provjerava postoji li WARNING u log i ispisuje zadnju (ili zadnjih N) WARNING linija
- Prikazuje ukupan broj ERROR i WARNING zapisa (COUNT)

## Kako se koristi
'''bash
/check_severity_test.sh
/check_severity_test.sh /path/do/loga
/check_severity_test.sh /path/do/loga 5
