#!/bin/bash

args=$(getopt -a -o d:f:c:i:o:w:s:l:hV --long dockerfile:,compose-file:,container-name:,image-name:,opt-dir:,port80:,port443:,linux:,help,Version -- "$@")

if [[ $? -gt 0 ]]; then
  usage
fi

function usage() {
	echo "${0} aus unbekannter Releaseversion für die Erstellung eines LoxBerry Docker-Containers"
 	echo ""
        echo "Hilfe ist wirklich vorgesehen"
 	echo "starte ohne Parameter und wir fragen alles ab"
  	echo ""
   	echo "das script legt die Werte in die Datei DockerBuild/docker_build-Information ab"
        echo "mit -d [filename] oder --dockerfile [filename] kannst Du eine solche Datei übergeben und er übernimmt daraus die Werte"
	echo ""
        echo "-h, -V --help, --Version zeigt dir diese Hilfe an"
	echo ""
        echo "-f | --compose-file [filename] sagt wo das finale docker-compose.yml liegen soll."
	echo "-c | --container-name [containername] sagt dem Scrip wie der Container im Docker genannt werden soll."
        echo "-i | --image-name [imagename] sagt dem Scrip wie der Image in der Docker-Registry genannt werden soll."
	echo "-o | --opt-dir [/pfad/zu/dockervolumes/] gibt einen Pfad an, wo der Container später sein /opt ablegen soll."
        echo "-w | --port80 [0-65000] gibt einen Port an, der an den Container auf Port 80 umgeleitet wird (w für web)"
	echo "-s | --port443 [0-65000] gibt einen Port an, der an den Container auf Port 443 umgeleitet wird (s für secure web)"
        echo "-l | --linux [11|12] gibt an welche Debian Distribution verwendet werden soll (noch nicht final umgesetz)"
	echo ""
}
	
unset DOCKER_COMPOSE_FILE
unset LOXBERRY_CONTAINER
unset LOXBERRY_IMAGENAME
unset LOXBERRY_OPT_DIR
unset DOCKER_NET_TCP_80
unset DOCKER_NET_TCP_443
unset DEBIAN_RELEASE

eval set -- ${args}
while :
do
  case $1 in
    -d | --dockerfile)		. $2                    ; shift 2  ;;
    -f | --compose-file)        DOCKER_COMPOSE_FILE=$2  ; shift 2  ;;	
    -c | --container-name)	LOXBERRY_CONTAINER=$2   ; shift 2  ;;
    -i | --image-name)		LOXBERRY_IMAGENAME=$2   ; shift 2  ;;
    -o | --opt-dir)		LOXBERRY_OPT_DIR=$2	; shift 2  ;;
    -w | --port80)		DOCKER_NET_TCP_80=$2	; shift 2  ;;
    -s | --port443)		DOCKER_NET_TCP_443=$2	; shift 2  ;;
    -l | --linux)               DEBIAN_RELEASE=$2       ; shift 2  ;;
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage ;;
  esac
done

if [ -z $DOCKER_COMPOSE_FILE ]; then
	read -p "DOCKER_COMPOSE_FILE nicht gesetzt, Bitte gib die docker-compose.yml inkl. Pfad an: " DOCKER_COMPOSE_FILE
fi
if [ -z $LOXBERRY_CONTAINER ]; then
	read -p "LOXBERRY_CONTAINER nicht gesetzt, Bitte gib einen Container-Namen an: " LOXBERRY_CONTAINER
fi
if [ -z $LOXBERRY_IMAGENAME ]; then
	read -p "LOXBERRY_IMAGENAME nicht gesetzt, Bitte gib einen Image-Namen an: " LOXBERRY_IMAGENAME
fi
if [ -z $LOXBERRY_OPT_DIR ]; then
	read -p "LOXBERRY_OPT_DIR nicht gesetzt, Bitte gib einen Pfad, in dem ich /opt ablegen darf an: " LOXBERRY_OPT_DIR
fi
if [ -z $DOCKER_NET_TCP_80 ]; then
	read -p "DOCKER_NET_TCP_80 nicht gesetzt, Bitte gib einen Port, über den Du port 80 des Containers erreichen willst an: " DOCKER_NET_TCP_80
fi
if [ -z $DOCKER_NET_TCP_443 ]; then
	read -p "DOCKER_NET_TCP_443 nicht gesetzt, Bitte gib einen Port, über den Du port 80 des Containers erreichen willst an: " DOCKER_NET_TCP_443
fi
if [ -z $DEBIAN_RELEASE ]; then
	read -p "DEBIAN_RELEASE nicht gesetzt, Bitte gib '11' oder '12' an um Dich für Debian11 oder Debian12 zu entscheiden: " DEBIAN_RELEASE
fi

(
echo DOCKER_COMPOSE_FILE=$DOCKER_COMPOSE_FILE
echo LOXBERRY_CONTAINER=$LOXBERRY_CONTAINER
echo LOXBERRY_IMAGENAME=$LOXBERRY_IMAGENAME
echo LOXBERRY_OPT_DIR=$LOXBERRY_OPT_DIR
echo DOCKER_NET_TCP_80=$DOCKER_NET_TCP_80
echo DOCKER_NET_TCP_443=$DOCKER_NET_TCP_443
echo DEBIAN_RELEASE=$DEBIAN_RELEASE
echo DOCKER_VERSION="$(docker --version | sed 's/ //g' )" 
) > DockerBuild/docker_build-Information

cat DockerBuild/docker_build-Information 
read -p "weiter machen, ansonsten STRG-C"

cd DockerBuild
chmod 777 docker-entrypoint.sh 			## Warning this is a security fail!
docker build -t ${LOXBERRY_IMAGENAME} --build-arg DEBIAN_RELEASE="${DEBIAN_RELEASE}" -f LoxBerry3.dockerfile .
cd -
#
echo "ab hier gehts leider aktuell noch manuell weiter"
echo ""
echo "docker run -it --privileged --name ${LOXBERRY_IMAGENAME}_temp ${LOXBERRY_IMAGENAME} /bin/bash"
echo ""
echo "/bin/bash /root/install-loxberry.sh"
echo "CTRL-D zum schließen"
echo "docker commit ${LOXBERRY_IMAGENAME}_temp ${LOXBERRY_IMAGENAME}:latest"
echo ""
echo "und dann das hier anfügen an ${DOCKER_COMPOSE_FILE}"
echo ""
echo "============================================================================================================================================================="

# Vorbereitet noch nicht machen, noch zu viel manuelles zu tun ..

# grep -v ^# dockerRun/compose_template.yml | sed "s#%LOXBERRY_CONTAINER%#${LOXBERRY_CONTAINER}#g" | sed "s#%LOXBERRY_IMAGENAME%#${LOXBERRY_IMAGENAME}#g" | sed "s#%LOXBERRY_OPT_DIR%#${LOXBERRY_OPT_DIR}#g"     | sed "s#%DOCKER_NET_TCP_80%#${DOCKER_NET_TCP_80}#g"   | sed "s#%DOCKER_NET_TCP_443%#${DOCKER_NET_TCP_443}#g"  >> ${DOCKER_COMPOSE_FILE} 

# echo "Super!", folgendes habe ich Deiner Config unter ${DOCKER_COMPOSE_FILE} hinzugefügt:"
echo ""

grep -v ^# dockerRun/compose_template.yml | sed "s#%LOXBERRY_CONTAINER%#${LOXBERRY_CONTAINER}#g" | sed "s#%LOXBERRY_IMAGENAME%#${LOXBERRY_IMAGENAME}#g" | sed "s#%LOXBERRY_OPT_DIR%#${LOXBERRY_OPT_DIR}#g"     | sed "s#%DOCKER_NET_TCP_80%#${DOCKER_NET_TCP_80}#g"   | sed "s#%DOCKER_NET_TCP_443%#${DOCKER_NET_TCP_443}#g"  

echo "============================================================================================================================================================="
echo ""
echo "docker dc startet dann deinen Container (hoffentlich :-)"
echo ""
echo "Vielen Dank für die Nutzung des Scripts"
