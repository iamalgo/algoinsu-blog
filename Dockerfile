FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy config template
COPY config.production.json /tmp/config.template.json

# Create startup script to substitute variables
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'sed "s/MYSQL_HOST_PLACEHOLDER/$RAILWAY_PRIVATE_DOMAIN/g; s/MYSQL_PASSWORD_PLACEHOLDER/$MYSQL_ROOT_PASSWORD/g; s/MYSQL_DATABASE_PLACEHOLDER/$MYSQL_DATABASE/g" /tmp/config.template.json > /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'exec docker-entrypoint.sh node current/index.js' >> /startup.sh && \
    chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
