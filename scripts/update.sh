#!/bin/bash

#Configuración.
input="./scripts/modlist.txt"
steamcmd_path="./steamcmd/steamcmd.sh"
ark_dir="/home/servers/ARK_TESTING"
steam_mod_dir="/home/servers/ARK_TESTING/steamapps/workshop/content/346110/*"
ark_mod_dir="/home/servers/ARK_TESTING/ShooterGame/Content/Mods/"
user=anonymous
password=

rm -r $ark_mod_dir;
echo Actualizando el Servidor de ARK.
Actualiza el servidor de ARK.
$steamcmd_path +login anonymous +force_install_dir $ark_dir +app_update 376030 validate +quit;

echo Actualizando Mods.
#Actualizando archivos de mod.
while IFS= read -r var 
     do
       $steamcmd_path +login $user $password +force_install_dir $ark_dir +workshop_download_item 346110 $var validate +quit;
      echo Mod "$var" actualizado.;
     done < "$input"

echo Servidor de ARK actulizado, incluídos los mods.;
#echo Moviendo los Mods al directorio destino.;
#Moviendo los mods a la carpeta destino.
#mv  -v $steam_mod_dir $ark_mod_dir;
#Establece permisos en el directorio destino.
#chmod -R 777 $ark_mod_dir;
#echo Copiados todos los Mods.
