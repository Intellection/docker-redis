#!/bin/bash

. /opt/redis/scripts/lib.sh
. /opt/redis/scripts/environment.sh

log "Getting master info."
mapfile -t REDIS_SENTINEL_INFO < <(get_sentinel_master_info)

if [[ ${#REDIS_SENTINEL_INFO[@]} == 0 ]]; then
    log "Master not found, becoming the master."
    REDIS_REPLICATION_MODE="master"
else
    log "Master found, becoming a replica."
    REDIS_REPLICATION_MODE="replica"
    REDIS_MASTER_HOST=${REDIS_SENTINEL_INFO[0]}
    REDIS_MASTER_PORT=${REDIS_SENTINEL_INFO[1]}
    log "Master is ${REDIS_MASTER_HOST}:${REDIS_MASTER_PORT}."
fi

log "Updating configuration."
cp /opt/redis/mounted/etc/redis.conf /opt/redis/etc/redis.conf

{
    echo
    echo "replica-announce-port ${REDIS_PORT}"
    echo "replica-announce-ip $(get_full_hostname "${HOSTNAME}")"
} >> /opt/redis/etc/redis.conf

if [[ "$REDIS_REPLICATION_MODE" = "replica" ]]; then
    echo "replicaof ${REDIS_MASTER_HOST} ${REDIS_MASTER_PORT}" >> /opt/redis/etc/redis.conf
fi

log "Configuration update complete."
log "Starting redis server."

exec redis-server /opt/redis/etc/redis.conf
