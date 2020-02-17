#!/bin/bash

sudo apt-get update

#install dialogs
# sudo apt-get install dialog apt-utils -y

#JAVA SETUP
sudo apt install openjdk-11-jdk-headless -y

#Export java home
echo "export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))" | sudo tee -a /etc/profile

#import profile
source /etc/profile

#export path
echo "export PATH=$PATH:$JAVA_HOME/bin" | sudo tee -a /etc/profile
echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" | sudo tee -a /etc/profile

#import updated profile
source /etc/profile

#installing all the required java certificates
#sudo dpkg --purge --force-depends ca-certificates-java
sudo apt-get install ca-certificates-java

#install maven
sudo apt-get install maven -y

#TOMCAT SETUP
#create user tomcat for secutity purposes
sudo groupadd tomcat
sudo mkdir /opt/tomcat
sudo useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

#go to temp to download binaries
cd /tmp/
curl -O http://apache.spinellicreations.com/tomcat/tomcat-9/v9.0.31/bin/apache-tomcat-9.0.31.tar.gz

## unzip
sudo tar xzvf apache-tomcat-9.0.31.tar.gz -C /opt/tomcat --strip-components=1

#go to tomcat folder
cd /opt/

#configure tomcat users permissions and update permissions for conf
sudo chmod -R 777 tomcat/

sudo chown -R tomcat tomcat/

cd /opt/tomcat/
sudo chgrp -R tomcat /opt/tomcat

sudo chmod -R g+r conf
sudo chmod g+x conf

sudo chown -R tomcat webapps/ work/ temp/ logs/

# sudo nano /etc/systemd/system/tomcat.service

## Writing a tomcat service to make it start on boot
# sudo touch /etc/systemd/system/tomcat.service
echo "after touch"
# echo "[Unit]
#     Description=Apache Tomcat Web Application Container
#     After=syslog.target network.target
#     [Service]
#     Type=forking
#     Environment=JAVA_HOME=/usr/lib/jvm/jre
#     Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
#     Environment=CATALINA_HOME=/opt/tomcat
#     Environment=CATALINA_BASE=/opt/tomcat
#     Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
#     Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
#     WorkingDirectory=/opt/tomcat
#     ExecStart=/opt/tomcat/bin/startup.sh
#     ExecStop=/bin/kill -15 $MAINPID
#     User=tomcat
#     Group=tomcat
#     UMask=0007
#     RestartSec=10
#     Restart=always
#     [Install]
#     WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/tomcat.service

echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target
[Service]
Type=oneshot
Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
WorkingDirectory=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
RemainAfterExit=true
ExecStop=/opt/tomcat/bin/shutdown.sh
User=tomcat
Group=tomcat
UMask=0007
[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/tomcat.service


# RestartSec=10
# Restart=always
# sudo update-rc.d tomcat defaults 95
# make webapp and work available to all and delete prepolutated examples
# cd /opt/
# sudo chmod -R 777 tomcat/
# sudo rm -rf /opt/tomcat/webapps/*
# sudo rm -rf /opt/tomcat/work/*

# echo"after chmod tp webapp folder"

#Reload  and run tomcat service
sudo systemctl daemon-reload
#sudo systemctl start tomcat
sudo systemctl status tomcat.service

# sudo ufw allow 8080
sudo systemctl unmask tomcat.service

sudo systemctl enable tomcat.service


sudo sed -i '$ d' /opt/tomcat/conf/tomcat-users.xml
sudo echo -e "\t<role rolename=\"manager-gui\"/>
\t<user username=\"manager\" password=\"manager\" roles=\"manager-gui\"/>
</tomcat-users>" | sudo tee -a /opt/tomcat/conf/tomcat-users.xml
    # sudo systemctl restart tomcat.service

    # sudo systemctl stop tomcat.service

    sudo systemctl status tomcat.service
    sudo su
    sudo chmod -R 777 webapps
    sudo chmod -R 777 work
    # sudo rm -rf /opt/tomcat/webapps/*
    # sudo rm -rf /opt/tomcat/work/*
    sudo ls /opt/tomcat/webapps

    sudo systemctl start tomcat.service
# sudo systemctl enable tomcat.service
# sudo systemctl start tomcat.service