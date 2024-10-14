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

log "Starting Redis server"
REDIS_PASSWORD="$(cat $REDIS_USER_PASSWORD)"
redis-server --requirepass $REDIS_PASSWORD /etc/redis/redis.conf
