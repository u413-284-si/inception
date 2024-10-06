#!/bin/bash


# Logging functions
log() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] $1" >> /var/log/wordpress/wordpress.log
}

error() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] ERROR: $1" >&2 >> /var/log/wordpress/wordpress.error.log
    exit 1
}

mkdir -p /var/log/wordpress/
chown -R $(whoami) /var/log/wordpress/
chmod -R 755 /var/log/wordpress/

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

log "Download the core WordPress files"
./wp-cli.phar core download --allow-root

log "Create wp-config.php"
WORDPRESS_DB_USER_PASSWORD="$(cat /run/secrets/db_user_password)"
if ! ./wp-cli.phar config create \
		--dbname=$WORDPRESS_DB_NAME \
		--dbuser=$WORDPRESS_DB_USER \
		--dbpass="$WORDPRESS_DB_USER_PASSWORD" \
		--dbhost=$MARIADB_HOST \
		--allow-root; then
	log "Failed to create wp-config.php with the wp-cli."
else
    log "wp-config.php created successfully."
fi

log "Install WordPress"
WORDPRESS_ADMIN_PASSWORD="$(cat /run/secrets/wordpress_admin_password)"
if ! ./wp-cli.phar core install \
		--url=$DOMAIN \
		--title=$TITLE \
		--admin_user=$WORDPRESS_ADMIN \
		--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_MAIL" \
		--allow-root; then
	log "Failed to install wordpress with the wp-cli."
else
    log "wordpress installed successfully."
fi

exec $@
