#!/bin/sh
ergebnis=$(ping -qc1 telefonica.es) 
ok=$?
avg=$(echo -e "$ergebnis"  | tail -n1 | awk '{print $4}' | cut -f 2 -d "/")

if [ $ok -eq 0 ]
then
        echo "Latencia desde España: OK $avg ms"
else
        echo "FAIL"
fi

