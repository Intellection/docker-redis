#!/bin/bash

response=$(
    redis-cli \
    -h localhost \
    -p "${REDIS_PORT}" \
    ping
)

if [ "$response" != "PONG" ] && [ "${response:0:7}" != "LOADING" ] && [ "${response:0:10}" != "MASTERDOWN" ]; then
    echo "$response"
    exit 1
fi

echo "$response"
