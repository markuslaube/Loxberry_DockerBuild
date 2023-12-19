#!/bin/bash
cd /tmp
git clone https://github.com/MichaIng/DietPi.git 
mkdir /boot/dietpi
mkdir /boot/loxberry
cp /tmp/DietPi/dietpi.txt /boot/
cd /tmp/DietPi/dietpi
cp -r * /boot/dietpi/
echo 'G_DIETPI_INSTALL_STAGE=-2' > /boot/dietpi/.install_stage 
bash /boot/dietpi/func/dietpi-obtain_hw_model
. /boot/dietpi/func/dietpi-globals
G_VERSIONDB_SAVE
# For the following steps, we need information that this is a prepared Docker image.
echo "Loxberry Docker Image" > /boot/loxberry/.docker
cd /tmp
rm -rf /tmp/DietPi
