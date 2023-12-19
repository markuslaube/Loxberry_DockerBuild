cd /tmp
git clone https://github.com/MichaIng/DietPi.git 
mkdir /boot/dietpi
mkdir /boot/loxberry/.docker
cp /tmp/DietPi/dietpi.txt /boot/
cd /tmp/DietPi/dietpi
cp -r * /boot/dietpi/
echo 'G_DIETPI_INSTALL_STAGE=-2' > /boot/dietpi/.install_stage 
bash /boot/dietpi/func/dietpi-obtain_hw_model
. /boot/dietpi/func/dietpi-globals
G_VERSIONDB_SAVE
cd /tmp
rm -rf /tmp/DietPi
