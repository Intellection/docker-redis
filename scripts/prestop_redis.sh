#!/bin/bash

. /opt/redis/scripts/lib.sh
. /opt/redis/scripts/environment.sh

run_redis_command() {
    redis-cli -h localhost -p "${REDIS_PORT}" "$@"
}

failover_finished() {
    REDIS_ROLE=$(run_redis_command role | head -1)
    [[ "${REDIS_ROLE}" != "master" ]]
}

if ! failover_finished; then
    log "Waiting for sentinel to failover for up to ${FAILOVER_GRACE_PERIOD_SECONDS}s."
    retry_while "failover_finished" "${FAILOVER_GRACE_PERIOD_SECONDS}" 1
else
    exit 0
fi
