#!/bin/sh
input="./scripts/country.txt" 

while IFS=";" read country host
     do
	   operacion=$(ping -qc1 $host)
ok=$?
avg=$(echo -e "$operacion"  | tail -n1 | awk '{print $4}' | cut -f 2 -d "/")
if [ $ok -eq 0 ]
then
        echo "Respuesta desde $country: $avg ms"
else
        echo "FALLO: No hay respuesta desde el destino."
fi

     done < "$input"
