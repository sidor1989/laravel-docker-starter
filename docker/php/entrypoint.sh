#!/bin/sh
set -e

# Access host from a docker container bufferings/docker-access-host
HOST_DOMAIN="host.docker.internal"
if ! ping -q -c1 $HOST_DOMAIN > /dev/null 2>&1
then
  HOST_IP=$(ip route | awk 'NR==1 {print $3}')
  # shellcheck disable=SC2039
  echo "$HOST_IP\t$HOST_DOMAIN" >> /etc/hosts
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"
