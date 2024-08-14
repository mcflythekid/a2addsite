#!/bin/bash
action=$1
domain=$2
alias=$3
email='/dev/null'
configFile="/etc/apache2/sites-available/$domain.conf"
sslConfig="$domain-le-ssl.conf"
sslConfigFile="/etc/apache2/sites-available/$sslConfig"
rootDir="/var/www/$domain"
publicHtml="$rootDir/public_html"

### validate
if [ "$action" != "add" ] && [ "$action" != "del" ]  && [ "$action" != "upgrade" ]; then
	echo $"Usage:
	\$ sudo a2addsite add domain_name [alias_name]
	\$ sudo a2addsite add domain_name [\"alias_name1 alias_name2\"]
	\$ sudo a2addsite del domain_name
	\$ sudo a2addsite upgrade
	"
    exit 0;
fi
if [ "$(whoami)" != 'root' ]; then
	echo -e $"You have no permission to run $0 as non-root user. Use sudo"
	exit 1;
fi


### upgrade
if [ "$action" == 'upgrade' ]; then
    cd ~
    rm -rf tmp_a2addsite
    git clone https://github.com/mcflythekid/a2addsite.git tmp_a2addsite
    cp -rf ./tmp_a2addsite/a2addsite.sh /usr/local/bin/a2addsite
    chmod +x /usr/local/bin/a2addsite
    echo $"Upgraded"
    exit 0;
fi


### validate for add / del
if [ "$domain" == "" ]; then
    echo -e $"Domain is required"
    exit 1;
fi

### add
if [ "$action" == 'add' ]; then

    ### validate
    if [ "$alias" == "" ]; then
        alias=domain
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
            Options -Indexes +FollowSymLinks +MultiViews
            AllowOverride all
            Require all granted
        </Directory>
        ErrorLog /var/log/apache2/$domain-error.log
        LogLevel error
        CustomLog /var/log/apache2/$domain-access.log combined
    </VirtualHost>" > $configFile
    then
        echo -e $"There is an ERROR creating $domain file"
        exit 1;
    else
        echo -e $"\nNew Virtual Host Created\n"
    fi

    ### enable website
    a2ensite $domain

    ### restart Apache
    /etc/init.d/apache2 reload

    ### show the finished message
    echo -e $"Complete! \nYou now have a new Virtual Host \nYour new host is: http://$domain \nAnd its located at $publicHtml"
    exit 0;

### delete
else
        ### check whether domain already exists
		if ! [ -e $configFile ]; then
			echo -e $"This domain does not exist.\nPlease try another one"
			exit;
		else

			### disable website
			a2dissite $domain
			a2dissite $sslConfig

			### restart Apache
			/etc/init.d/apache2 reload

			### Delete virtual host rules files
			rm $configFile
			rm $sslConfigFile

            ### check if directory exists or not
            if [ -d $rootDir ]; then
                echo -e $"Delete host root directory ? (y/n)"
                read deldir

                if [ "$deldir" == 'y' -o "$deldir" == 'Y' ]; then
                    ### Delete the directory
                    rm -rf $rootDir
                    echo -e $"Directory deleted"
                else
                    echo -e $"Host directory conserved"
                fi
            else
                echo -e $"Host directory not found. Ignored"
            fi

            ### show the finished message
            echo -e $"Complete!\nYou just removed Virtual Host $domain"
            exit 0;
		fi
fi

# END
