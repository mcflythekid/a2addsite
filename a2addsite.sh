#!/bin/bash
domain=$1
alias=$2
email='/dev/null'
configFile="/etc/apache2/sites-available/$domain.conf"
rootDir="/var/www/$domain"
publicHtml="$rootDir/public_html"

### validate
if [ "$domain" == "" ]; then
	echo $"Usage: sudo a2addsite domain_name [\"alias_name1 alias_name2\"]"
	exit;
fi
if [ "$alias" == "" ]; then
	alias=domain
fi
if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
	exit 1;
fi
if [ -e $configFile ]; then
    echo -e $"This domain already exists.\nPlease Try Another one"
    exit 1;
fi

### create directory if needed
if ! [ -d $rootDir ]; then
    mkdir -p $publicHtml
    ### write test file in the new domain dir
    if ! echo "<?php echo phpinfo(); ?>" > $publicHtml/index.php
    then
        echo $"ERROR: Not able to write in file $publicHtml/index.php. Please check permissions"
        exit 1;
    else
        echo $"Added content to $publicHtml/index.php"
    fi
fi

### give permission to root dir
chmod -R 775 $rootDir
chmod -R g+s $rootDir
chown -R $SUDO_USER:$SUDO_USER $rootDir

### create virtual host rules file
if ! echo "
<VirtualHost *:80>
    ServerAdmin $email
    ServerName $domain
    ServerAlias $alias
    DocumentRoot $publicHtml
    <Directory />
        AllowOverride All
    </Directory>
    <Directory $publicHtml>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
        Require all granted
    </Directory>
    ErrorLog /var/log/apache2/$domain-error.log
    LogLevel error
    CustomLog /var/log/apache2/$domain-access.log combined
</VirtualHost>" > $configFile
then
    echo -e $"There is an ERROR creating $domain file"
    exit;
else
    echo -e $"\nNew Virtual Host Created\n"
fi

### enable website
a2ensite $domain

### restart Apache
/etc/init.d/apache2 reload

### show the finished message
echo -e $"Complete! \nYou now have a new Virtual Host \nYour new host is: http://$domain \nAnd its located at $publicHtml"
exit;
