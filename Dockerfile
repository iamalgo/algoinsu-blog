FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config template
COPY config.production.json /tmp/config.template.json

# Create startup script to configure Ghost via Environment Variables and theme setting
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'set -e' >> /startup.sh && \
    echo 'echo "Cleaning up old config files..."' >> /startup.sh && \
    echo 'rm -f /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'rm -f /var/lib/ghost/config.development.json' >> /startup.sh && \
    # Use printf to reliably create the JSON config with the theme
    echo 'printf '"'"'"'{"theme": "algoinsu"}'"'"'"'"'"'"' > /var/lib/ghost/config.production.json' >> /startup.sh && \
    # Also write to dev config just in case
    echo 'cp /var/lib/ghost/config.production.json /var/lib/ghost/config.development.json' >> /startup.sh && \
    echo 'export url="https://$RAILWAY_PUBLIC_DOMAIN"' >> /startup.sh && \
    echo 'export process=local' >> /startup.sh && \
    echo 'export server__host=0.0.0.0' >> /startup.sh && \
    echo 'export server__port=2368' >> /startup.sh && \
    echo 'export paths__contentPath=/var/lib/ghost/content' >> /startup.sh && \
    echo 'export database__client=sqlite3' >> /startup.sh && \
    echo 'export database__connection__filename=/var/lib/ghost/content/ghost.db' >> /startup.sh && \
    echo 'export NODE_ENV=development' >> /startup.sh && \
    echo 'echo "Starting Ghost..."' >> /startup.sh && \
    echo 'exec node current/index.js 2>&1' >> /startup.sh && \
    chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
