#!/bin/bash

if [ $(id -u) != 0 ] 
	then
   	echo "\033[1;37;40mThis script must be run as root user . \nGo back and try again as root user\033[0m" 
   	exit 1
fi

sudo apt-get update
sudo apt-get install -y python-pip apache2 libapache2-mod-wsgi

echo '\033[1;37;40m  Enter Project Name eg. myproject \033[0m'
read projectname
echo '\033[1;37;40m  Enter full path of your project eg. /home/username/myproject/ \n make sure path start and end with / \033[0m'
read projectpath
echo '\033[1;37;40m' 
echo $projectname'/static/ is your static file path press (y or n) \033[0m'
read choice

if [ "$choice" = "n" ]
	then
	echo '\033[1;37;40m  Enter  full Path of your static Directory \033[0m'
	read staticpath
fi

echo '\033[1;37;40m  Enter  DNS name  \033[0m'
read Dns
echo '\033[1;37;40m  Enter  Email Address  \033[0m'
read Email

#sudo chown :www-data ~/myproject

virtualhost="
<VirtualHost *:80>\n \
    ServerName $Dns\n \
    ServerAlias www.$Dns\n \
    ServerAdmin $Email\n \
	Alias /static/ $staticpath \n \
	<Directory $staticpath>\n \
		Require all granted\n \
	</Directory>\n \
    WSGIDaemonProcess $projectname python-path=$projectpath:/usr/local/lib/python2.7/ \n \
    WSGIProcessGroup $projectname\n \
    WSGIScriptAlias / $projectpath$projectname/wsgi.py \n \
    <Directory $projectpath$projectname/> \n \
		<Files wsgi.py>\n \
			Require all granted\n \
		</Files>\n \
	</Directory>\n \
	#ErrorLog    log file path\n \
    #CustomLog   access file path combined\n \
</VirtualHost>\n \
"

echo $virtualhost > /etc/apache2/sites-available/$projectname.conf
chown -R :www-data $projectpath
chmod -R 664 $projectpath

a2dissite $projectname.conf
a2ensite $projectname.conf
service apache2 restart

echo '\033[1;37;40m  If running apache server at localhost make entry of DNS in /etc/hosts/ file \n if any permission denied error occur see log /var/log/apache2/error.log or access.log  and change group of this file to www-data using chown :www-data filename\033[0m'
echo '\033[1;37;40m you can see ur project path here /etc/apache2/sites-available/'$projectname.conf
echo 'if something wrong edit it and save after that run this'
echo 'a2dissite '$projectname.conf
echo 'a2densite '$projectname.conf
echo 'and reload or restart apache2 server \033[0m'