ARG DEBIAN_RELEASE
ENV DEBIAN_RELEASE=${DEBIAN_RELEASE}
FROM debian:${DEBIAN_RELEASE}
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get -y install apt-utils
RUN apt-get -y install apt-transport-https lsb-release ca-certificates gnupg2 curl
RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
RUN curl -sSLo /usr/share/keyrings/dl.yarnpkg.com.asc https://dl.yarnpkg.com/debian/pubkey.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN echo "deb [signed-by=/usr/share/keyrings/dl.yarnpkg.com.asc] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get -y update && apt-get -y install yarn  # wenn ich das über die packageliste  mache kommt bei mir ein fehler database outdatet
RUN apt-get -y upgrade
RUN apt-cache dumpavail | dpkg --merge-avail
COPY apt-packages_${DEBIAN_RELEASE}.txt /tmp/apt-packages.txt
RUN dpkg --set-selections < /tmp/apt-packages.txt
RUN apt-get -y dselect-upgrade
RUN apt-get -y update
RUN adduser --shell /bin/bash --home /home/dietpi --disabled-password --gecos "DietPi" dietpi
COPY root_known_hosts /root/.ssh/known_hosts
COPY preinstall.sh /tmp/
RUN /bin/bash /tmp/preinstall.sh
COPY docker_build-Information /boot/loxberry/.docker
COPY dphys-swapfile.service /boot/docker/
COPY networking.service /boot/docker/
COPY wpa_supplicant.service /boot/docker/
COPY build-systemd.sh /boot/docker/
COPY install_${DEBIAN_RELEASE}.sh /root/install-loxberry.sh
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
