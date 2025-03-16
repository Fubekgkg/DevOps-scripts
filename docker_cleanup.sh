#!/bin/bash

LOG_FILE="/var/log/docker_cleanup.log"

echo_log() {
    echo "[$(date)] $1" | tee -a "$LOG_FILE"
}

echo_log "Starting Docker cleanup..."

echo_log "Removing stopped containers..."
docker container prune -f

echo_log "Removing dangling images..."
docker image prune -f

echo_log "Removing unused networks..."
docker network prune -f

echo_log "Removing unused volumes..."
docker volume prune -f

echo_log "Cleaning up Docker logs..."
find /var/lib/docker/containers/ -type f -name "*.log" -delete

echo_log "Docker cleanup completed."

exit 0