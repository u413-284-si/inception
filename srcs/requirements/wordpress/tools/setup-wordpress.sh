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

# Check if wordpress is already downloaded
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
else
    log "WordPress core files already exist."
fi

if ! wp core is-installed --allow-root; then
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
else
    log "WordPress is already installed."
fi

if ! wp user list --field=user_login --allow-root | grep -q "^$WORDPRESS_USER$"; then
	log "Create WordPress user"
	USER_PASSWORD="$(cat $WORDPRESS_USER_PASSWORD)"
	if ! wp user create $WORDPRESS_USER "$WORDPRESS_USER_MAIL" \
			--role=author \
			--user_pass="$USER_PASSWORD" \
			--allow-root; then
		error "Failed to create wordpress user"
	fi
else
    log "WordPress user already exists."
fi

if ! wp plugin is-installed redis-cache --allow-root; then
	log "Installing redis cache"
	wp plugin install redis-cache --activate --allow-root
	# Redis Host, Port, and other basic settings
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_REDIS_PORT 6379 --allow-root
	wp config set WP_REDIS_PREFIX 'redis' --allow-root
	wp config set WP_REDIS_DATABASE 0 --allow-root
	wp config set WP_REDIS_TIMEOUT 1 --allow-root
	wp config set WP_REDIS_READ_TIMEOUT 1 --allow-root
	# Additional Redis settings
	wp config set WP_CACHE_KEY_SALT 'sqiu42' --allow-root
	wp config set WP_REDIS_MAXTTL 86400 --allow-root
	wp config set WP_REDIS_COMPRESSION true --allow-root
else
    log "Redis cache is already installed."
fi

if ! wp redis status --allow-root | grep -q "Connected"; then
    log "Enabling redis cache"
    wp redis enable --allow-root
else
    log "Redis cache is already enabled."
fi

wp core verify-checksums --allow-root

exec $@
