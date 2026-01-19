FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config template
COPY config.production.json /tmp/config.template.json

# Create startup script with robust fallback logic
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'set -e' >> /startup.sh && \
    echo 'echo "Generating config..."' >> /startup.sh && \
    # 1. Try to replace the placeholder
    echo 'sed -e "s|GHOST_URL_PLACEHOLDER|https://$RAILWAY_PUBLIC_DOMAIN|g" /tmp/config.template.json > /var/lib/ghost/config.production.json' >> /startup.sh && \
    # 2. FALLBACK: If sed didn't work (e.g., placeholder was missing), 
    #    append the URL directly to the config file to force it to exist.
    echo 'if ! grep -q "https://" /var/lib/ghost/config.production.json; then' >> /startup.sh && \
    echo '  echo "{\"url\": \"https://$RAILWAY_PUBLIC_DOMAIN\"}" > /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'fi' >> /startup.sh && \
    echo 'echo "Final Config:"' >> /startup.sh && \
    echo 'cat /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'echo "Starting Ghost..."' >> /startup.sh && \
    echo 'exec docker-entrypoint.sh node current/index.js' >> /startup.sh && \
    chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
