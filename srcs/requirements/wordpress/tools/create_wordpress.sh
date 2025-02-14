#!/bin/sh

if [ -f ./wp-config.php ]
then
	echo "wordpress already downloaded"
else

	#Download wordpress and all config file
	wget http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	cp wordpress/wp-config-sample.php .
	mv wordpress/* /var/www/html/
	rm -rf latest.tar.gz
	# rm -rf wordpress

	#Inport env variables in the config file
	sed -i "s/username_here/${SQL_USER}/g" var/www/html/wp-config-sample.php
	sed -i "s/password_here/${SQL_PASSWORD}/g" var/www/html/wp-config-sample.php
	sed -i "s/localhost/${SQL_HOSTNAME}/g" var/www/html/wp-config-sample.php
	sed -i "s/database_name_here/${SQL_DATABASE}/g" var/www/html/wp-config-sample.php
	cp var/www/html/wp-config-sample.php var/www/html/wp-config.php

fi

exec "$@"