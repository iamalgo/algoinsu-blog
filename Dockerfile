FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config template
COPY config.production.json /tmp/config.template.json

# Create startup script to substitute variables and start Ghost
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'set -e' >> /startup.sh && \
    echo 'echo "Generating config..."' >> /startup.sh && \
    echo 'sed -e "s|GHOST_URL_PLACEHOLDER|https://$RAILWAY_PUBLIC_DOMAIN|g" \
    -e "s|MYSQL_HOST_PLACEHOLDER|$MYSQLHOST|g" \
    -e "s|MYSQL_USER_PLACEHOLDER|$MYSQLUSER|g" \
    -e "s|MYSQL_PASSWORD_PLACEHOLDER|$MYSQLPASSWORD|g" \
    -e "s|MYSQL_DATABASE_PLACEHOLDER|$MYSQLDATABASE|g" \
    /tmp/config.template.json > /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'echo "Starting Ghost..."' >> /startup.sh && \
    echo 'exec docker-entrypoint.sh node current/index.js' >> /startup.sh && \
    chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
