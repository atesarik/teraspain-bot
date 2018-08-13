#!/bin/bash
#
#TSPBOT 
#Versión Actual.
#@Designed by @flowese 
#Powered by HubSpain Servers.
VERSION="1.5.0"

# token predeterminado y ChatID
# o ejecuta TSPBot con la opción: -t <token>
TELEGRAMTOKEN="AQUI VA EL TOKEN DE TELEGRAM";


# Tiempo de refresco en checkear nuevos mensajes.
# o ejecuta TSPBot con la opción: -c <segundos>
CHECKNEWMSG=2;

# COMANDOS
# Para añadir nuevos comandos debes usar esta sintaxis exacta: ["/micomando"] = '<comando del sistema>'
# Por favor, no te olvides de eliminar todos los comandos de ejemplo!
#
# Por favor se consciente de la seguridad de tu sistema, no expongas ejecutables que puedan atentar en contra de tus sistemas. 

declare -A botcommands
botcommands=(
##Comandos de interacción.
	["/hola"]='echo "Hola @FIRSTNAME, soy el bot oficial de TERASPAIN, estoy aquñi para ayudarte."'
       ["/adios"]='echo "Adiós @FIRSTNAME, un placer conocerte, que tengas un buen día :D"'
	["/team"]='echo Master Admins:; echo "@flowese"; echo "@blind"'
##Comandos de Inicio y Ayuda.	
	["/start"]="./scripts/helpmenu.sh"
	["/ayuda"]="./scripts/helpmenu.sh"
	["/help"]="./scripts/helpmenu.sh"
##Comandos de Sistema. 	
	["/uptime"]="uptime -p"
	["/ping (.*)"]="ping -c 1 -t 1 -W 1 @R1"
	["/pingc"]="./scripts/globalping.sh"
	["/whois ([a-zA-Z0-9\.\-]+)"]="/usr/bin/whois @R1" 	
	["/short (.*)"]="./scripts/short.sh -s @R1"
	["/getip"]="./scripts/gethostip.sh"
	["/rebootds"]="./scripts/rebootsv.sh"
##Comandos de Plex. 
	["/plex ([a-zA-Z0-9\.\-]+)"]="service plexmediaserver @R1"
	["/plexscan"]="./scripts/pmsc.sh"
##Comandos de ARK:TSP.
	["/synctime"]="./scripts/set_sync_es.sh"
	["/setday"]="./scripts/set_time_day.sh"
	["/setnight"]="./scripts/set_time_night.sh"
	["/players"]="./scripts/listplayers.sh"
	["/getchat"]="./scripts/getchat.sh"
	["/getlog"]="./scripts/getgamelog.sh"	
	["/saveworld"]="./scripts/saveworld.sh"
	["/vermods"]="./scripts/vermods.sh"
	["/updatemods"]="./scripts/update.sh"
	["/backup"]="./scripts/backup.sh"
	["/version"]="./scripts/version.sh"
	["/rcon ([a-zA-Z0-9\.\-]+)"]="mcrcon -s -c -H xxx.xxx.xxx.xxx -P xxxx -p XXXXXX @R1"
)

# + end config
# +
# +
# +

FIRSTTIME=0;
BOTPATH="$( cd "$( dirname "$0" )" && pwd )"

echo "+"
while getopts :ht:c: OPTION; do
	case $OPTION in
		h)
			echo " TSPBot: Bash Telegram Bot"
			echo "+"
			echo " Uso: ${0} [-t <token>] [-c <seconds>]"
			exit;
		;;
		t)
			echo "Establecer token: ${OPTARG}";
			TELEGRAMTOKEN=$OPTARG;
		;;
		c)
			echo "Comprobar mensajes nuevos cada: ${OPTARG} segundos";
			CHECKNEWMSG=$OPTARG;
		;;
	esac
done
echo "+"

echo -en "\n"

echo ".-------------------------------------------------."
echo "| TSPBot v${VERSION}                                   |" 
echo "| Autor: flowese                                  |"
echo "| Powered by: HUBSPAIN SERVERS                    |"
echo "| Web: https://hubspain.com                       |"
echo "| Twitter: https://twitter.com/flowese            |"
echo "| Github: Próximamente                            |"
echo -e "._________________________________________________.\n"

ABOUTME=`curl -s "https://api.telegram.org/bot${TELEGRAMTOKEN}/getMe"`
if [[ "$ABOUTME" =~ \"ok\"\:true\, ]]; then
	if [[ "$ABOUTME" =~ \"username\"\:\"([^\"]+)\" ]]; then
		MYUSERNAME=${BASH_REMATCH[1]}
		echo -e "Usuario: ${BASH_REMATCH[1]}";
	fi

	if [[ "$ABOUTME" =~ \"first_name\"\:\"([^\"]+)\" ]]; then
		MYFIRSTNAME=${BASH_REMATCH[1]}
		echo -e "Nombre: ${BASH_REMATCH[1]}";
	fi

	if [[ "$ABOUTME" =~ \"id\"\:([0-9\-]+), ]]; then
		echo "Bot ID: ${BASH_REMATCH[1]}";
		BOTID=${BASH_REMATCH[1]};
	fi

else
	echo "Error: por favor, revisa el token de telegram... exit.";
	exit;
fi

LASTFCOUNT=$(ls -1 ${BOTPATH}/lastid/*.lastmsg 2>/dev/null | wc -l)
if [ $LASTFCOUNT -eq 0 ]; then
	FIRSTTIME=0;
else
	FIRSTTIME=1;
fi

echo -e "Preparado. Esperando nuevos mensajes...\n"
MSGID=0;
CHATID=0;
TEXT=0;
FIRSTNAME="";
LASTNAME="";

while true; do
	MSGOUTPUT=$(curl -s "https://api.telegram.org/bot${TELEGRAMTOKEN}/getUpdates" | bash ${BOTPATH}/inc/JSON.sh -b);

	echo -e "${MSGOUTPUT}" | while read -r line ; do
		LASTLINERCVD=${line};

		if [[ "$line" =~ ^\[\"result\"\,[0-9]+\,\"message\"\,\"message\_id\"\][[:space:]]+([0-9]+) ]]; then
			MSGID=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ ^\[\"result\"\,[0-9]+\,\"message\"\,\"chat\"\,\"id\"\][[:space:]]+([0-9\-]+)$ ]]; then
			CHATID=${BASH_REMATCH[1]};
			if [ ! -f ${BOTPATH}/lastid/${BOTID}-${CHATID}.lastmsg ]; then
				echo -n 0 > ${BOTPATH}/lastid/${BOTID}-${CHATID}.lastmsg
			fi
		fi

		if [[ "$line" =~ ^\[\"result\"\,[0-9]+\,\"message\"\,\"from\"\,\"id\"\][[:space:]]+([0-9]+)$ ]]; then
			FROMID=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ ^\[\"result\"\,[0-9]+\,\"message\"\,\"from\"\,\"first\_name\"\][[:space:]]+\"(.+)\"$ ]]; then
			FIRSTNAME=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ ^\[\"result\"\,[0-9]+\,\"message\"\,\"from\"\,\"last\_name\"\][[:space:]]+\"(.+)\"$ ]]; then
			LASTNAME=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ ^\[\"result\"\,[0-9]+\,\"message\"\,\"from\"\,\"username\"\][[:space:]]+\"(.+)\"$ ]]; then
			USERNAME=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ ^\[\"result\"\,[0-9]+\,\"message\"\,\"text\"\][[:space:]]+\"(.+)\"$ ]]; then
			TEXT=${BASH_REMATCH[1]};


			if [[ $MSGID -ne 0 && $CHATID -ne 0 ]]; then
				LASTMSGID=$(cat "${BOTPATH}/lastid/${BOTID}-${CHATID}.lastmsg");
				if [[ $MSGID -gt $LASTMSGID ]]; then
					#echo -ne "\r\033[K"
					FIRSTNAMEUTF8=$(echo -e "$FIRSTNAME");
					echo -n "[chat "; printf "%-12s" "${CHATID}"; echo "] <@${USERNAME}> (${FIRSTNAMEUTF8} ${LASTNAME}): ${TEXT}";
					echo $MSGID > "${BOTPATH}/lastid/${BOTID}-${CHATID}.lastmsg";

					for s in "${!botcommands[@]}"; do
						if [[ "$TEXT" =~ ${s} ]]; then
							CMDORIG=${botcommands["$s"]};
							CMDORIG=${CMDORIG//@USERID/$FROMID};
							CMDORIG=${CMDORIG//@USERNAME/$USERNAME};
							CMDORIG=${CMDORIG//@FIRSTNAME/$FIRSTNAMEUTF8};
							CMDORIG=${CMDORIG//@LASTNAME/$LASTNAME};
							CMDORIG=${CMDORIG//@CHATID/$CHATID};
							CMDORIG=${CMDORIG//@MSGID/$MSGID};
							CMDORIG=${CMDORIG//@TEXT/$TEXT};
							CMDORIG=${CMDORIG//@FROMID/$FROMID};
							CMDORIG=${CMDORIG//@R1/${BASH_REMATCH[1]}};
							CMDORIG=${CMDORIG//@R2/${BASH_REMATCH[2]}};
							CMDORIG=${CMDORIG//@R3/${BASH_REMATCH[3]}};

							echo "Comando ${s} recibido, ejecutando script: ${CMDORIG}"
							CMDOUTPUT=`$CMDORIG`;

							if [ $FIRSTTIME -eq 1 ]; then
								echo "mensaje antiguo, no se enviará comunicación al usuario.";
							else
								curl -s -d "text=${CMDOUTPUT}&chat_id=${CHATID}" "https://api.telegram.org/bot${TELEGRAMTOKEN}/sendMessage" > /dev/null
							fi
						fi
					done


					#echo -ne "\r\033[K"
					#clr_green "${MYUSERNAME}" -n; echo -en "> "

				fi
			fi
		fi
	done

	FIRSTTIME=0;

	read -t $CHECKNEWMSG answer;
	if [[ "$answer" =~ ^\.msg.([\-0-9]+).(.*) ]]; then
		CHATID=${BASH_REMATCH[1]};
		MSGSEND=${BASH_REMATCH[2]};
		curl -s -d "text=${MSGSEND}&chat_id=${CHATID}" "https://api.telegram.org/bot${TELEGRAMTOKEN}/sendMessage" > /dev/null;
	elif [[ "$answer" =~ ^\.msg.([a-zA-Z]+).(.*) ]]; then
		CHATID=${BASH_REMATCH[1]};
		MSGSEND=${BASH_REMATCH[2]};
		curl -s -d "text=${MSGSEND}&chat_id=@${CHATID}" "https://api.telegram.org/bot${TELEGRAMTOKEN}/sendMessage" > /dev/null;
	fi

	sleep $CHECKNEWMSG
done
