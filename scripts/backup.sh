#!/bin/sh
namebk=Saved;
cp -r /home/servers/ARK_TSP/ShooterGame/Saved/ /home/servers/backups/ARKSE-TSP/Saved_TSP;
echo Copia realizada, comprimiendo ficheros...
cd /home/servers/backups/ARKSE-TSP/;
zip -r $namebk.zip Saved_TSP/*;
rm -r Saved_TSP;
echo Backup completado con éxito.;
