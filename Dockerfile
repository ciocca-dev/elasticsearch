# Start with the official Elasticsearch image
FROM docker.io/library/elasticsearch:7.10.1

# Copy configuration files
COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY roles.yml /usr/share/elasticsearch/config/roles.yml

# Copy and set permissions for the entrypoint script
COPY --chmod=755 entrypoint-new.sh /usr/local/bin/entrypoint-new.sh

# Install sudo and configure permissions
RUN yum update -y && \
    yum install -y sudo && \
    echo "elasticsearch ALL=(root) NOPASSWD: /bin/chown" > /etc/sudoers.d/elasticsearch && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint-new.sh"]

# Expose the default Elasticsearch port
EXPOSE 9200 9300

# Set the default command
CMD ["elasticsearch"]