#!/bin/bash

response=$(
    redis-cli \
    -h localhost \
    -p "${REDIS_PORT}" \
    ping
)

if [ "$response" != "PONG" ]; then
    echo "$response"
    exit 1
fi

echo "$response"
