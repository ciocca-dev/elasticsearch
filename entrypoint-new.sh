#!/bin/bash
set -e

# Files created by Elasticsearch should always be group writable too
umask 0002

if [[ "$(id -u)" == "0" ]]; then
    echo "Elasticsearch cannot run as root. Please start as the elasticsearch user."
    exit 1
fi

# Ensure proper permissions on mounted volumes
sudo chown -R elasticsearch:elasticsearch /var/lib/elasticsearch /var/log/elasticsearch

exec elasticsearch