#!/bin/bash

set -eo pipefail

echo "--------------------------------"

export HOSTNAME="${PODNAME}.kea.kea.svc.cluster.local"
echo "Bootstrapping at $(date) on ${HOSTNAME}"

MY_V6="$(ip -6 addr show dev eth0 | grep 2001 | awk '{print $2}' | sed 's/\/.*//g')"

echo "--------------------------------"
echo "DB config"
echo "Host: ${KEA_DB_HOST}"
echo "Port: ${KEA_DB_PORT}"
echo "User: ${KEA_DB_USER}"
echo "Database: ${KEA_DB_DB}"
echo "HOSTNAME: ${HOSTNAME}"
# KEA_DB_PASSWORD is not printed
envsubst '$KEA_DB_HOST,$KEA_DB_PORT,$KEA_DB_USER,$KEA_DB_DB,$KEA_DB_PASSWORD,$HOSTNAME' < /etc/kea/kea-dhcp4.conf.env > /etc/kea/kea-dhcp4.conf
sed -i "s/\"interfaces\": \[ \]/\"interfaces\": \[ \"$MY_V6\" \]/g" /etc/kea/kea-dhcp6.conf.env
envsubst '$KEA_DB_HOST,$KEA_DB_PORT,$KEA_DB_USER,$KEA_DB_DB,$KEA_DB_PASSWORD,$HOSTNAME' < /etc/kea/kea-dhcp6.conf.env > /etc/kea/kea-dhcp6.conf
envsubst '$KEA_DB_HOST,$KEA_DB_PORT,$KEA_DB_USER,$KEA_DB_DB,$KEA_DB_PASSWORD,$HOSTNAME,$DDNS_KEY' < /etc/kea/kea-ddns.conf.env > /etc/kea/kea-ddns.conf

echo "Startmode: $1 $2"

if [ "$1" = "agent" ] ; then
  exec /usr/sbin/kea-ctrl-agent -c /etc/kea/kea-ctrl-agent.conf
elif [ "$1" = "dhcpv6" ]; then
  exec /usr/sbin/kea-dhcp6 -c /etc/kea/kea-dhcp6.conf
elif [ "$1" = "ddns" ]; then
  exec /usr/sbin/kea-dhcp-ddns -c /etc/kea/kea-ddns.conf
else
  exec /usr/sbin/kea-dhcp4 -c /etc/kea/kea-dhcp4.conf
fi