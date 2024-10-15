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

mkdir -p /var/www/html/adminer
cp index.php /var/www/html/adminer/index.php
cp adminer.php /var/www/html/adminer/adminer.php

log "Starting Adminer"
exec "$@"
