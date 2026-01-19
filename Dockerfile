FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config template
COPY config.production.json /tmp/config.template.json

# Create startup script to configure Ghost via Environment Variables
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'set -e' >> /startup.sh && \
    echo 'echo "Cleaning up old config files..."' >> /startup.sh && \
    # Aggressively remove any existing config files to ensure we start fresh
    echo 'rm -f /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'rm -f /var/lib/ghost/config.development.json' >> /startup.sh && \
    # Configure Ghost via Environment Variables (bypasses JSON parsing)
    echo 'export url="https://$RAILWAY_PUBLIC_DOMAIN"' >> /startup.sh && \
    echo 'export process=local' >> /startup.sh && \
    echo 'export server__host=0.0.0.0' >> /startup.sh && \
    echo 'export server__port=2368' >> /startup.sh && \
    echo 'export paths__contentPath=/var/lib/ghost/content' >> /startup.sh && \
    echo 'export database__client=sqlite3' >> /startup.sh && \
    echo 'export database__connection__filename=/var/lib/ghost/content/data/ghost.db' >> /startup.sh && \
    echo 'echo "Starting Ghost with Environment Config..."' >> /startup.sh && \
    # Start Ghost. It will ignore JSON files and use these exports instead.
    echo 'exec docker-entrypoint.sh node current/index.js' >> /startup.sh && \
    chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
