#!/bin/bash

if [ $(id -u) != 0 ] 
	then
   	echo "\033[1;37;40mThis script must be run as root user . \nGo back and try again as root user\033[0m" 
   	exit 1
fi
echo $(hostname)
echo '\033[1;37;40m  Updating and installing packages \033[0m'

sudo apt-get update
sudo apt-get install -y postfix dovecot-common dovecot-pop3d dovecot-imapd mailutils

echo '\033[1;37;40m'
service dovecot status
service postfix status
echo '\033[0m'

#changing in postfix file
touch aliases transport

#chaing in main.cf
printf '\n transport_maps = hash:/etc/postfix/transport \n'

sed -i 's/.*inet_interfaces.*/inet_interfaces = all /' /etc/postfix/main.cf
sed -i 's/.*inet_interfaces = localhost.*/#inet_interfaces = localhost /' /etc/postfix/main.cf

#update aliases transport databases

postalias aliases
postmap transport
postmap hash:/etc/postfix/transport



# changing in dovecot confg file
#file path /etc/dovecot/conf.d/10-mail.conf

sed -i 's/.*mail_privileged.*/mail_privileged_group = mail /' /etc/dovecot/conf.d/10-mail.conf
sed -i 's/.*mail_location.*/mail_location = mbox:~/mail:INBOX=/var/mail/%u /' /etc/dovecot/conf.d/10-mail.conf

service dovecot restart
service postfix restart

echo '\033[1;37;40m'
echo 'For any error see log file\npath = /var/log/mail.log'
echo '\033[0m'

while true
do
	echo 'If you want to add new user press (y or n)'
	read choice
	if [ "$choice" = "y" ]
		then
			echo 'Enter New User name'
			read name
			echo 'Enter password'
			read password
			echo "$password\n$password\n\n\n\n\ny"|sudo adduser $name
			echo ' \n \033[1;37;40m'
			echo $name 
			echo 'added successfully as a user \033[0m\n'
		else
			break
	fi
done
