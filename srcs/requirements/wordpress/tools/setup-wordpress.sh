#!/bin/bash


# Logging functions
log() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] $1"
}

error() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] ERROR: $1" >&2
    exit 1
}

log "Download the core WordPress files"
wp core download --allow-root

log "Create wp-config.php"
WORDPRESS_DB_USER_PASSWORD="$(cat /run/secrets/db_user_password)"
if ! wp config create \
		--dbname=$WORDPRESS_DB_NAME \
		--dbuser=$WORDPRESS_DB_USER \
		--dbpass="$WORDPRESS_DB_USER_PASSWORD" \
		--dbhost=$MARIADB_HOST \
		--allow-root; then
	log "Failed to create wp-config.php with the wp-cli."
fi

log "Install WordPress"
WORDPRESS_ADMIN_PASSWORD="$(cat /run/secrets/wordpress_admin_password)"
if ! wp core install \
		--url=$DOMAIN \
		--title=$TITLE \
		--admin_user=$WORDPRESS_ADMIN \
		--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_MAIL" \
		--allow-root; then
	log "Failed to install wordpress with the wp-cli."
fi

log "Create WordPress user"
WORDPRESS_USER_PASSWORD="$(cat /run/secrets/wordpress_user_password)"
if ! wp user create $WORDPRESS_USER "$WORDPRESS_USER_MAIL" \
		--role=author \
		--user_pass="$WORDPRESS_USER_PASSWORD" \
		--allow-root; then
	log "Failed to create wordpress user"
else
    log "Wordpress user created successfully."
fi

exec $@
