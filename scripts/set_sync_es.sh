#!/bin/sh
spain_time=$(date +"%H:%M");
mcrcon -s -c -H 62.210.189.104 -P 27020 -p TEMPORADA "settimeofday $spain_time";
mcrcon -s -c -H 62.210.189.104 -P 27020 -p TEMPORADA  "Broadcast HORA ACTUAL DEL SERVIDOR: $spain_time";
echo Servidor sincronizado con la hora española. Son las $spain_time.;
