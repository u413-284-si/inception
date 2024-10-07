#!/bin/bash
set -e
set -o pipefail

DATADIR="/var/lib/mysql"

# Logging functions
log() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] $1"
}

error() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] ERROR: $1" >&2
    exit 1
}

# Ensure the user running this script has permissions to write to the data directory
if [ ! -w "$DATADIR" ]; then
    error "Data directory $DATADIR is not writable. Please ensure the correct permissions."
fi

# Initialize MariaDB data directory if it's not already initialized
if [ ! -w "$DATADIR/$WORDPRESS_DB_NAME" ]; then
	log "Initializing MariaDB data directory..."
	mariadb-install-db --datadir=$DATADIR --auth-root-authentication-method=normal --skip-test-db

	# Start temporary MariaDB server without networking
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

	# Create WordPress database and user
	log "Create WordPress database and user"
	if ! mariadb -u root <<-EOF
		CREATE DATABASE $WORDPRESS_DB_NAME;
	EOF
	then 
		error "Failed to create WordPress database"
	else
		log "WordPress database created successfully"
	fi

	WORDPRESS_USER_PASSWORD="$(cat $WORDPRESS_DB_USER_PASSWORD)"
	if ! mariadb -u root <<-EOF
		CREATE USER '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_USER_PASSWORD';
		GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
	EOF
	then
		error "Failed to create WordPress user"
	else
		log "WordPress user created successfully"
	fi

	# Set MariaDB root password
	log "Setting root password..."
	ROOT_PASSWORD="$(cat $MARIADB_ROOT_PASSWORD)"
	if ! mariadb -u root <<-EOF
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASSWORD';
	EOF
	then
		error "Failed to set MariaDB root password"
	else
		log "MariaDB root password set successfully"
	fi

	# Stop temporary MariaDB server
	log "Stop temporary server"
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
else
	log "Using existing MariaDB data directory"
fi

exec $@
