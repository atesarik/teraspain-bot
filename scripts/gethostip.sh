#!/bin/bash
ipserver=$(curl http://api.ipify.org);
echo La dirección pública del host es: $ipserver;
exit
