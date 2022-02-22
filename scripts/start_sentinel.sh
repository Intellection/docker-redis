#!/bin/bash

. /opt/redis/scripts/lib.sh
. /opt/redis/scripts/environment.sh

log "Getting master info."
mapfile -t REDIS_SENTINEL_INFO < <(get_sentinel_master_info)

if [[ ${#REDIS_SENTINEL_INFO[@]} == 0 ]]; then
    log "Master not found, becoming the master."
    REDIS_MASTER_HOST=$(get_full_hostname "${HOSTNAME}")
    REDIS_MASTER_PORT="${REDIS_PORT}"
else
    log "Master found, becoming a replica."
    REDIS_MASTER_HOST=${REDIS_SENTINEL_INFO[0]}
    REDIS_MASTER_PORT=${REDIS_SENTINEL_INFO[1]}
    log "Master is ${REDIS_MASTER_HOST}:${REDIS_MASTER_PORT}."
fi

log "Updating configuration."
cp /opt/redis/mounted/etc/sentinel.conf /opt/redis/etc/sentinel.conf

{
    echo
    echo "sentinel monitor ${REDIS_MASTER_GROUP} ${REDIS_MASTER_HOST} ${REDIS_MASTER_PORT} 2"
    echo "sentinel announce-hostnames yes"
    echo "sentinel resolve-hostnames yes"
    echo "sentinel announce-port ${SENTINEL_PORT}"
    echo "sentinel announce-ip $(get_full_hostname "${HOSTNAME}")"
} >> /opt/redis/etc/sentinel.conf

log "Configuration update complete."
log "Starting redis sentinel."

exec redis-sentinel /opt/redis/etc/sentinel.conf
