# Start with a specific CentOS 7 image
FROM centos:7.9.2009

# Install Java, as Elasticsearch requires it
RUN yum update -y && \
    yum install -y java-1.8.0-openjdk-headless && \
    yum clean all && \
    rm -rf /var/cache/yum

# Install Elasticsearch
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch && \
    echo "[elasticsearch-7.x]" > /etc/yum.repos.d/elasticsearch.repo && \
    echo "name=Elasticsearch repository for 7.x packages" >> /etc/yum.repos.d/elasticsearch.repo && \
    echo "baseurl=https://artifacts.elastic.co/packages/7.x/yum" >> /etc/yum.repos.d/elasticsearch.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/elasticsearch.repo && \
    echo "gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch" >> /etc/yum.repos.d/elasticsearch.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/elasticsearch.repo && \
    echo "autorefresh=1" >> /etc/yum.repos.d/elasticsearch.repo && \
    echo "type=rpm-md" >> /etc/yum.repos.d/elasticsearch.repo

RUN yum install -y elasticsearch-7.10.1 sudo && \
    yum clean all && \
    rm -rf /var/cache/yum

# Copy configuration files
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY roles.yml /etc/elasticsearch/roles.yml

# Copy and set permissions for the entrypoint script
COPY --chmod=755 entrypoint-new.sh /usr/local/bin/entrypoint-new.sh

# Configure sudo permissions
RUN echo "elasticsearch ALL=(root) NOPASSWD: /bin/chown" > /etc/sudoers.d/elasticsearch

# Set the correct ownership for Elasticsearch directories
RUN chown -R elasticsearch:elasticsearch /etc/elasticsearch /var/log/elasticsearch /var/lib/elasticsearch

# Switch to the elasticsearch user
USER elasticsearch

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint-new.sh"]

# Expose the default Elasticsearch ports
EXPOSE 9200 9300

# Set the default command
CMD ["elasticsearch"]