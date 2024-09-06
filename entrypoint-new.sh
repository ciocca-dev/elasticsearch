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

# Print the current PATH for debugging
echo "Current PATH: $PATH"

# Print directory permissions for debugging
echo "Permissions for /usr/share/elasticsearch/logs:"
ls -la /usr/share/elasticsearch/logs
echo "Permissions for /esdata:"
ls -la /esdata

# Use the full path to elasticsearch
exec /usr/share/elasticsearch/bin/elasticsearch