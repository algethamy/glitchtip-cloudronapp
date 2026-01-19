ARG GLITCHTIP_VERSION=latest
FROM glitchtip/glitchtip:${GLITCHTIP_VERSION}

USER root

# Install supervisor
RUN apt-get update && apt-get install -y supervisor && \
    rm -rf /var/lib/apt/lists/*

# Setup directory structure for Cloudron
# Cloudron will mount volumes at /app/data
RUN mkdir -p /app/data && chown -R glitchtip:glitchtip /app/data

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /app/code/start.sh

RUN chmod +x /app/code/start.sh

# Use start script as entrypoint
CMD ["/app/code/start.sh"]
