#!/bin/bash
#
# Vielen Dank an: AkihiroSuda
# this file is from https://github.com/AkihiroSuda/containerized-systemd/tree/master
# https://raw.githubusercontent.com/AkihiroSuda/containerized-systemd/master/docker-entrypoint.sh
#
set -e
container=docker
export container

if [ $# -eq 0 ]; then
        echo >&2 'ERROR: No command specified. You probably want to run `journalctl -f`, or maybe `bash`?'
        exit 1
fi

if [ ! -t 0 ]; then
        echo >&2 'ERROR: TTY needs to be enabled (`docker run -t ...`).'
        exit 1
fi

env >/etc/docker-entrypoint-env


cat >/etc/systemd/system/docker-entrypoint.target <<EOF
[Unit]
Description=the target for docker-entrypoint.service
Requires=docker-entrypoint.service systemd-logind.service systemd-user-sessions.service
EOF

quoted_args="$(printf " %q" "${@}")"
echo "${quoted_args}" >/etc/docker-entrypoint-cmd

cat >/etc/systemd/system/docker-entrypoint.service <<EOF
[Unit]
Description=docker-entrypoint.service

[Service]
ExecStart=/bin/bash -exc "source /etc/docker-entrypoint-cmd"
# EXIT_STATUS is either an exit code integer or a signal name string, see systemd.exec(5)
ExecStopPost=/bin/bash -ec "if echo \${EXIT_STATUS} | grep [A-Z] > /dev/null; then echo >&2 \"got signal \${EXIT_STATUS}\"; systemctl exit \$(( 128 + \$( kill -l \${EXIT_STATUS} ) )); else systemctl exit \${EXIT_STATUS}; fi"
StandardInput=tty-force
StandardOutput=inherit
StandardError=inherit
WorkingDirectory=$(pwd)
EnvironmentFile=/etc/docker-entrypoint-env

[Install]
WantedBy=multi-user.target
EOF

# deaktiviere "stoerende Dienste" auf etwas schmutzigere art, sinnvoller wäre ein mask, das hab ich aber noch nicht probiert
cp /boot/docker/dphys-swapfile.service /lib/systemd/system/
cp /boot/docker/networking.service /lib/systemd/system/
cp /boot/docker/wpa_supplicant.service /lib/systemd/system/

# andere dinge müssen vielleicht nicht gar so schmutzig abgeschalten werden
systemctl mask systemd-firstboot.service systemd-udevd.service systemd-modules-load.service
systemctl unmask systemd-logind
systemctl enable docker-entrypoint.service

if [ -e /boot/docker/.firstboot ]; then
        if [ ! -e /opt/loxberry ]; then mv /opt2/loxberry /opt/ ; fi 
	rm -rf /opt2
	## Todo --> Wir wollen das Passwort-Tool vom loxberry lehren bei einer änderung die Datei /opt/tools/etc_shadow_passes anzulegen
 	## zum testen hab ich die manuell erstellt
        if [ -e /opt/tools/etc_shadow_passes ]; then 
		shadow=$(cat /etc/shadow)
		for user in $( cat /opt/tools/etc_shadow_passes | awk -F: '{print $1}' ) ; do shadow=$(echo "$shadow" | grep -v ^"${user}:") ; done
		( cat /opt/tools/etc_shadow_passes ; echo "$shadow" ) > /etc/shadow
	fi
        rm -f /boot/docker/.firstboot
fi

if [ ! -e /boot/docker/.prebuild ]; then
        /bin/bash /boot/docker/build-systemd.sh
fi

systemd=
if [ -x /lib/systemd/systemd ]; then
        systemd=/lib/systemd/systemd
elif [ -x /usr/lib/systemd/systemd ]; then
        systemd=/usr/lib/systemd/systemd
elif [ -x /sbin/init ]; then
        systemd=/sbin/init
else
        echo >&2 'ERROR: systemd is not installed'
        exit 1
fi
systemd_args="--show-status=false --unit=docker-entrypoint.target"
echo "$0: starting $systemd $systemd_args"
exec $systemd $systemd_args
