FROM redis:6.2.6

# ARGs & ENVs
ARG SCRIPTS_PATH="/opt/redis/scripts/"

COPY scripts/ ${SCRIPTS_PATH}
