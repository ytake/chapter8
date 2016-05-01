#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
sudo ln -sf /usr/share/zoneinfo/Japan /etc/localtime
sudo locale-gen ja_JP.UTF-8
sudo /usr/sbin/update-locale LANG=ja_JP.UTF-8
sudo add-apt-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.1-dev
sudo gem install mailcatcher
mailcatcher --http-ip=0.0.0.0

block="description \"Mailcatcher\"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0
"
echo "$block" > "/etc/init/mailcatcher.conf"

sudo echo "opcache.revalidate_freq = 0" >> /etc/php/7.0/mods-available/opcache.ini
sudo echo "xdebug.idekey = PHPSTORM" >> /etc/php/7.0/mods-available/xdebug.ini

grep '^date.timezone = Asia/Tokyo' /etc/php/7.0/fpm/php.ini
if [ $? -eq 1 ]; then
sudo cat >> /etc/php5/fpm/php.ini << "EOF"
date.timezone = Asia/Tokyo
mbstring.language = Japanese
EOF
fi

grep '^date.timezone = Asia/Tokyo' /etc/php/7.0/cli/php.ini
if [ $? -eq 1 ]; then
sudo cat >> /etc/php5/cli/php.ini << "EOF"
date.timezone = Asia/Tokyo
mbstring.language = Japanese
EOF
fi

sudo service nginx restart
sudo service php5-fpm restart
#service mailcatcher start
