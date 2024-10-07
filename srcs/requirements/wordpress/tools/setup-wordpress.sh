#!/bin/bash
set -e
set -o pipefail

# Logging functions
log() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] $1"
}

error() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] ERROR: $1" >&2
    exit 1
}

# Check if wordpress is already installed
# Missing index.php: The site won't load.
# Missing wp-includes/version.php: The WordPress core is likely incomplete or broken.
if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then
	log "Download the core WordPress files"
	wp core download --allow-root

	log "Create wp-config.php"
	DB_USER_PASSWORD="$(cat $WORDPRESS_DB_USER_PASSWORD)"
	if ! wp config create \
			--dbname=$WORDPRESS_DB_NAME \
			--dbuser=$WORDPRESS_DB_USER \
			--dbpass="$DB_USER_PASSWORD" \
			--dbhost=$MARIADB_HOST \
			--allow-root; then
		error "Failed to create wp-config.php with the wp-cli."
	fi

	log "Install WordPress"
	ADMIN_PASSWORD="$(cat $WORDPRESS_ADMIN_PASSWORD)"
	if ! wp core install \
			--url=$DOMAIN \
			--title=$TITLE \
			--admin_user=$WORDPRESS_ADMIN \
			--admin_password="$ADMIN_PASSWORD" \
			--admin_email="$WORDPRESS_ADMIN_MAIL" \
			--allow-root; then
		error "Failed to install wordpress with the wp-cli."
	fi

	log "Create WordPress user"
	USER_PASSWORD="$(cat $WORDPRESS_USER_PASSWORD)"
	if ! wp user create $WORDPRESS_USER "$WORDPRESS_USER_MAIL" \
			--role=author \
			--user_pass="$USER_PASSWORD" \
			--allow-root; then
		error "Failed to create wordpress user"
	fi
else
	log "Wordpress is already setup."
	wp core verify-checksums
fi

exec $@
