### trigger mdns fix!!!!

DEBIAN_FRONTEND=noninteractive apt-get -y install python-pygame sense-hat

mysql -u root --password="$1" -e "CREATE DATABASE wordpress"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

rm /var/www/html/index.html
chgrp -R pi /var/www/html
chmod -R g+w /var/www/html

sudo -u pi -i -- wp core download --path=/var/www/html
sudo -u pi -i -- wp core config --path=/var/www/html --dbname=wordpress --dbuser=root --dbpass="$1"
sudo -u pi -i -- wp core install --path=/var/www/html --url=http://$(hostname).local/ --title="Blog In A Box" --admin_user="$2" --admin_email="email@example.com" --admin_password="$3" --skip-email
PLUGIN_LOCATION=`curl -I https://api.github.com/repos/tinkertinker/biab/zipball | perl -n -e '/^Location: (.*)$/ && print "$1\n"'`
sudo -u pi -i -- wp plugin install --path=/var/www/html $PLUGIN_LOCATION --activate
THEME_LOCATION=`curl -I https://api.github.com/repos/tinkertinker/biab-theme/zipball | perl -n -e '/^Location: (.*)$/ && print "$1\n"'`
sudo -u pi -i -- wp theme install --path=/var/www/html $THEME_LOCATION --activate

# install cron job
sudo -u pi -i -c '(crontab -l ; echo "* * * * * wp cron event run --due-now --path=/var/www/html") | crontab -'