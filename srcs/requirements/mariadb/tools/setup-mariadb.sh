#!/bin/bash
set -e
set -o pipefail

DATADIR="/var/lib/mysql"

# Logging functions
log() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] $1" >> /var/log/mariadb/mariadb.log
}

error() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] ERROR: $1" >&2 >> /var/log/mariadb/mariadb.error.log
    exit 1
}

mkdir -p /var/log/mariadb/
chown -R $(whoami) /var/log/mariadb/
chmod -R 755 /var/log/mariadb/

# Ensure the user running this script has permissions to write to the data directory
if [ ! -w "$DATADIR" ]; then
    error "Data directory $DATADIR is not writable. Please ensure the correct permissions."
fi

# Initialize MariaDB data directory if it's not already initialized
if [ ! -w "$DATADIR/$WORDPRESS_DB_NAME" ]; then
	log "Initializing MariaDB data directory..."
	mariadb-install-db --datadir=$DATADIR --auth-root-authentication-method=normal --skip-test-db

	log "Start temporary MariaDB server without networking"
	mariadbd --skip-networking &
	MARIADB_PID=$!

	log "Wait for server to start..."
	for i in {30..0}; do
		if mariadb -u root --database=mysql <<<'SELECT 1' &> /dev/null; then
			break
		fi
		sleep 1
	done

	if [ "$i" = 0 ]; then
		error "Unable to start MariaDB"
	fi

	log "Setting root password..."
	MARIADB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
	mariadb -u root <<-EOF
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';
	EOF

	log "Create WordPress database and user"
	WORDPRESS_DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
	mariadb -u root <<-EOF
		CREATE DATABASE $WORDPRESS_DB_NAME;
		CREATE USER '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_USER_PASSWORD';
		GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
	EOF

	log "Stop temporary server"
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
else
	log "Using existing MariaDB data directory"
fi

exec $@
