#!/bin/bash

set -eo pipefail

echo "--------------------------------"

echo "Bootstrapping at $(date) on $(hostname -f)"

echo "--------------------------------"
echo "DB config"
echo "Host: ${KEA_DB_HOST}"
echo "Port: ${KEA_DB_PORT}"
echo "User: ${KEA_DB_USER}"
echo "Database: ${KEA_DB_DB}"
export HOSTNAME="$(hostname -f)"
echo "HOSTNAME: ${HOSTNAME}"
# KEA_DB_PASSWORD is not printed
envsubst '$KEA_DB_HOST,$KEA_DB_PORT,$KEA_DB_USER,$KEA_DB_DB,$KEA_DB_PASSWORD,$HOSTNAME' < /etc/kea/kea-dhcp4.conf.env > /etc/kea/kea-dhcp4.conf
envsubst '$KEA_DB_HOST,$KEA_DB_PORT,$KEA_DB_USER,$KEA_DB_DB,$KEA_DB_PASSWORD,$HOSTNAME' < /etc/kea/kea-dhcp6.conf.env > /etc/kea/kea-dhcp6.conf

echo "Startmode: $1 $2"

if [ "$1" = "agent" ] ; then
  exec /usr/sbin/kea-ctrl-agent -c /etc/kea/kea-ctrl-agent.conf
elif [ "$1" = "dhcpv6" ]; then
  exec /usr/sbin/kea-dhcp6 -c /etc/kea/kea-dhcp6.conf
else
  exec /usr/sbin/kea-dhcp4 -c /etc/kea/kea-dhcp4.conf
fi