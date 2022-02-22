#!/bin/bash

log() {
    echo "$1"
}

retry_while() {
    local cmd="${1:?cmd is missing}"
    local retries="${2:-12}"
    local sleep_time="${3:-5}"
    local return_value=1

    read -r -a command <<<"$cmd"
    for ((i = 1; i <= retries; i += 1)); do
        "${command[@]}" && return_value=0 && break
        sleep "$sleep_time"
    done
    return $return_value
}

get_full_hostname() {
    echo "${1}.${REDIS_HEADLESS_SERVICE}"
}

get_sentinel_master_info() {
    timeout 5 redis-cli -h "${REDIS_SERVICE}" -p "${SENTINEL_PORT}" sentinel get-master-addr-by-name "${REDIS_MASTER_GROUP}"
}
