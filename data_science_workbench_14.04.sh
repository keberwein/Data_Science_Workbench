#!/bin/bash
# Bash script for setting up a fresh data scince server on Ubuntu 14.04
# To run: ./data_science_toolbox.sh

echo ""
echo "###################################################"
echo "This utility will setup a new Ubuntu 14.04 LTS Desktop instance as a data science server."
echo "This script will install and configure the following tools:"
echo " - Jupyter Notebook (formerly IPython)"
echo " - Jupyterhub"
echo " - Rstudio-Server"
echo " - Shiny-Server"
echo ""
echo ""
echo "Create a user and password for rstudio-server."
echo "###################################################"
echo ""
read -p "RStudio user group [rstudio_users]: " rstudioGroup
rstudioGroup=${rstudioGroup:-rstudio_users}
read -p "Create RStudio user: " rstudioUser
read -s -p "Password for $rstudioUser: " rstudioPassword
read -s -p "Confirm password: " rstudioPassword_confirm
if [ "$rstudioPassword" != "$rstudioPassword_confirm" ]
	then
		echo ""
		echo "rstudio-server user passwords did not match! Re-run the script!"
		exit
fi
echo ""
echo ""
echo "Updating Ubuntu system software"
echo "###################################################"
echo ""
sudo apt-get -yy update && sudo apt-get -yy upgrade
echo ""
echo "Installing dependencies. This may take a minute!"
echo "###################################################"
echo ""
sudo apt-get -yy install git
sudo apt-get -yy install openssh-server openssh-client
sudo apt-get -yy install libssl-dev libcurl4-openssl-dev
sudo apt-get -yy install libxml2-dev libzmq3-dev libpq-dev
sudo apt-get -yy install ubuntu-dev-tools gdebi-core libapparmor1 psmisc 
sudo apt-get -yy install libtool autoconf automake uuid-dev octave 

echo ""
echo ""
sudo groupadd $rstudioGroup
sudo useradd -m -N $rstudioUser
echo "$rstudioUser:$rstudioPassword" | sudo chpasswd
sudo usermod -a -G $rstudioGroup $rstudioUser
sudo chmod -R +u+r+w /home/$rstudioUser

echo ""
echo ""
echo "Installing R and Rstudio-Server"
echo "###################################################"

echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee -a /etc/apt/sources.list
gpg --keyserver pgp.mit.edu --recv-key 51716619E084DAB9
gpg -a --export 51716619E084DAB9 > cran.asc
sudo apt-key add cran.asc
sudo rm cran.asc

sudo apt-get -yy install r-base r-base-dev
sudo apt-get update
sudo apt-get -yy install r-base r-base-dev
sudo sed -i 's@R_LIBS_USER@#R_LIBS_USER@' /usr/lib/R/etc/Renviron
sudo sed -i 's@##R_LIBS_USER@R_LIBS_USER@' /usr/lib/R/etc/Renviron
sudo wget https://download2.rstudio.org/rstudio-server-0.99.451-amd64.deb
sudo gdebi -n rstudio-server-0.99.451-amd64.deb
rserver_config="/etc/rstudio/rserver.conf"
rsession_config="/etc/rstudio/rsession.conf"
sudo touch $rserver_config
sudo touch $rsession_config
echo "auth-required-user-group=$rstudioGroup"  | sudo tee -a $rserver_config
echo "r-cran-repos=deb http://cran.rstudio.com/bin/linux/ubuntu trusty/"  | sudo tee -a $rsession_config
sudo chmod -R 777 /usr/local/lib/R/site-library
sudo chmod 777 /usr/lib/R/site-library
sudo rstudio-server restart

echo ""
echo ""
echo "Installing Anaconda." 
echo "###################################################"
echo ""
sudo wget "https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh"
sudo bash Anaconda3-4.2.0-Linux-x86_64.sh -b -p /opt/anaconda3
echo ""
cd
echo 'export PATH="/opt/anaconda3/bin:$PATH"' >> ~/.bashrc
echo ""
sudo chmod -R 777 /opt/anaconda3
echo ""
cd /opt/anaconda3/bin/ 
./conda install -f --yes node-webkit
cd

echo ""
echo ""
echo "Installing Jupyter Hub aka Ipython Server"
echo "###################################################"
echo ""
sudo apt-get -yy install npm nodejs-legacy
sudo npm install -g configurable-http-proxy
/opt/anaconda3/bin/./pip install jupyterhub

echo ""
echo ""
echo "Downloading, installing, and configuring shiny-server"
echo "###################################################"
echo ""
sudo apt-get -yy install openjdk-7-jdk
export LD_LIBRARY_PATH=/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server
sudo R CMD javareconf  
sudo su - -c "R -e \"install.packages(c('shiny', 'rmarkdown', 'devtools', 'RCurl'), repos='http://cran.rstudio.com/')\""
sudo wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.4.6.809-amd64.deb
sudo sudo gdebi shiny-server-1.4.6.809-amd64.deb
echo ""
echo ""
echo "Setting permissions for Shiny"
echo "###################################################"
echo ""
sudo chmod -R 777 /srv/shiny-server
echo ""

# Start up the server!!
echo ""
echo "###################################################"
echo "INSTALLTION COMPLETE!"
echo "The RStudio server is available at http:[server-url]:8787"
echo "shiny-server pages can be accessed at http:[server-url]:3838"
echo "shiny-server pages can be accessed at http:[server-url]:8000"
echo "To start the Jupyther Hub type: jupyterhub"
exit

