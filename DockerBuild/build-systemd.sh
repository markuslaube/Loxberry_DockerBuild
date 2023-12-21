#!/bin/bash

cd /etc/systemd/system/multi-user.target.wants

for service in * ; do

  if [ ! -e /etc/systemd/system/docker-entrypoint.target.wants/${service} ] ; then /usr/bin/systemctl add-wants docker-entrypoint.target ${service} ; fi

done

cd -
