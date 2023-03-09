#!/bin/bash
chown -R www-data:www-data /var/www
cd /var/www/
if [ ! -f /usr/local/bin/wp ]; then
  # Install the WordPress CLI
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -f /var/www/wp-config.php ]; then  
  wp core download --locale=ru_RU --allow-root
  sh /var/www/wp-config-create.sh
fi
# This snippet is injected into the wp-config.php file when it is created;
# it informs WordPress that we are behind a reverse proxy and as such
# allows it to generate links using HTTPS

wp config set 'FORCE_SSL_ADMIN' 'true' 

# Install WordPress
wp core install \
  --url="localhost" \
  --title="${WP_TITLE}" \
  --admin_user="${WP_ADMIN_NAME}" \
  --admin_password="${WP_ADMIN_PASSWORD}" \
  --admin_email="${WP_ADMIN_EMAIL}" \
  --allow-root

wp user create \
  "${WP_USER_NAME}" "${WP_USER_EMAIL}" \
  --user_pass="${WP_USER_PASSWORD}" \
  --role=author \
  --allow-root

wp theme install twentyseventeen --activate --allow-root

# Remove sample file because it is cruft and could be a security problem
rm /var/www/wp-config-sample.php
rm /var/www/wp-config-create.sh

wp plugin install redis-cache --activate --allow-root
wp plugin update --all --allow-root

# Ensure that WordPress permissions are correct
# find /var/www -type d -exec chmod g+s {};
chmod g+w -R /var/www/wp-content
# chmod -R g+w /var/www/wp-content/themes
# chmod -R g+w /var/www/wp-content/plugins

# wp redis enable --allow-root

exec "$@";