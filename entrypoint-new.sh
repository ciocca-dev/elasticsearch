#!/bin/bash
set -e

# Files created by Elasticsearch should always be group writable too
umask 0002

# Ensure Elasticsearch is in the PATH
export PATH=$PATH:/usr/share/elasticsearch/bin

if [[ "$(id -u)" == "0" ]]; then
    echo "Elasticsearch cannot run as root. Please start as the elasticsearch user."
    exit 1
fi

# Ensure proper permissions on mounted volumes
sudo chown -R elasticsearch:elasticsearch /var/lib/elasticsearch /var/log/elasticsearch

# Print the current PATH for debugging
echo "Current PATH: $PATH"

# Use the full path to elasticsearch
exec /usr/share/elasticsearch/bin/elasticsearch