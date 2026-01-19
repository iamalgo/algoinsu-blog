FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config template
COPY config.production.json /tmp/config.template.json

# Create startup script with BOM stripping and JSON validation
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'set -e' >> /startup.sh && \
    echo 'echo "Generating config..."' >> /startup.sh && \
    # Copy the template
    echo 'cp /tmp/config.template.json /var/lib/ghost/config.production.json' >> /startup.sh && \
    # REMOVE the BOM (Invisible character that breaks JSON parsing)
    echo 'sed -i "1s/^\xEF\xBB\xBF//" /var/lib/ghost/config.production.json' >> /startup.sh && \
    # Replace URL
    echo 'sed -i -e "s|GHOST_URL_PLACEHOLDER|https://$RAILWAY_PUBLIC_DOMAIN|g" /var/lib/ghost/config.production.json' >> /startup.sh && \
    # Fallback if placeholder missing
    echo 'if ! grep -q "https://" /var/lib/ghost/config.production.json; then' >> /startup.sh && \
    echo '  echo "{\"url\": \"https://$RAILWAY_PUBLIC_DOMAIN\"}" > /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'fi' >> /startup.sh && \
    echo 'echo "Final Config:"' >> /startup.sh && \
    echo 'cat /var/lib/ghost/config.production.json' >> /startup.sh && \
    # Validate JSON (This will stop the script and show a clear error if JSON is bad)
    echo 'node -e "JSON.parse(require(\"fs\").readFileSync(\"/var/lib/ghost/config.production.json\"))"' >> /startup.sh && \
    echo 'echo "Config is valid. Starting Ghost..."' >> /startup.sh && \
    echo 'exec docker-entrypoint.sh node current/index.js' >> /startup.sh && \
    chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
