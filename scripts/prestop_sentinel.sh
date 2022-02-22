#!/bin/bash

. /opt/redis/scripts/lib.sh
. /opt/redis/scripts/environment.sh

run_sentinel_command() {
    redis-cli -h localhost -p "${SENTINEL_PORT}" sentinel "$@"
}

failover_finished() {
    mapfile -t REDIS_SENTINEL_INFO < <(run_sentinel_command get-master-addr-by-name "${REDIS_MASTER_GROUP}")
    REDIS_MASTER_HOST="${REDIS_SENTINEL_INFO[0]}"
    [[ "${REDIS_MASTER_HOST}" != "$(get_full_hostname "${HOSTNAME}")" ]]
}

if ! failover_finished; then
    log "We are the master, starting sentinel failover."
    run_sentinel_command failover "${REDIS_MASTER_GROUP}"

    if retry_while "failover_finished" "${FAILOVER_GRACE_PERIOD_SECONDS}" 1; then
        log "Failover completed successfully."
        exit 0
    else
        log "Failover failed."
        exit 1
    fi
else
    exit 0
fi
