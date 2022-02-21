#!/bin/bash

: ${REDIS_MASTER_GROUP:?"Environment variable not set."}
: ${REDIS_HEADLESS_SERVICE:?"Environment variable not set."}
: ${REDIS_SERVICE:?"Environment variable not set."}
: ${REDIS_PORT:?"Environment variable not set."}
: ${SENTINEL_PORT:?"Environment variable not set."}
: ${FAILOVER_GRACE_PERIOD_SECONDS:?"Environment variable not set."}
