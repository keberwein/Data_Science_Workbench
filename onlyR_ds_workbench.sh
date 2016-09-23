#!/bin/bash
# Bash script for setting up a fresh data scince server on Ubuntu 16.04
# To run: ./data_science_toolbox.sh

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
echo "Installing R and Rstudio-Server"
echo "###################################################"
echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
gpg --keyserver pgp.mit.edu --recv-key 51716619E084DAB9
gpg -a --export 51716619E084DAB9 > cran.asc
sudo apt-key add cran.asc
sudo rm cran.asc
sudo apt-get -yy install r-base r-base-dev
sudo apt-get update
sudo apt-get -yy install r-base r-base-dev
sudo sed -i 's@R_LIBS_USER@#R_LIBS_USER@' /usr/lib/R/etc/Renviron
sudo sed -i 's@##R_LIBS_USER@R_LIBS_USER@' /usr/lib/R/etc/Renviron
echo "r-cran-repos=deb http://cran.rstudio.com/bin/linux/ubuntu xenial/"  | sudo tee -a $rsession_config
sudo chmod -R 777 /usr/local/lib/R/site-library
sudo chmod 777 /usr/lib/R/site-library
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
exit

