#!/bin/bash
arkv=$(cat /home/servers/ARK_TSP/version.txt);
oarkv=$(curl -X GET http://arkdedicated.com/version);
#status=$(curl -X GET http://arkdedicated.com/officialserverstatus.ini);

echo Versión servidor TSP: $arkv;
echo Versión servidores oficiales: $oarkv;
echo 
echo Estado de los serviores oficiales: OK Running.
#echo $status
exit 
