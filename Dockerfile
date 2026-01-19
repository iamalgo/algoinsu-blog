FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config and custom entry point
COPY config.production.json /tmp/config.template.json
COPY index.js /var/lib/ghost/index.js
COPY package.json /var/lib/ghost/package.json

# Install express only (already pre-installed Ghost is in /var/lib/ghost/versions/5.84.0)
RUN npm install express

# Set Node path to find Ghost pre-installed in the image
ENV NODE_PATH=/var/lib/ghost/versions/5.84.0/node_modules:/var/lib/ghost/node_modules

# Create startup script to substitute variables
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'sed -e "s/MYSQL_HOST_PLACEHOLDER/$MYSQLHOST/g" -e "s/MYSQL_USER_PLACEHOLDER/$MYSQLUSER/g" -e "s/MYSQL_PASSWORD_PLACEHOLDER/$MYSQLPASSWORD/g" -e "s/MYSQL_DATABASE_PLACEHOLDER/$MYSQLDATABASE/g" -e "s|GHOST_URL_PLACEHOLDER|https://$RAILWAY_PUBLIC_DOMAIN|g" /tmp/config.template.json > /var/lib/ghost/config.production.json' >> /startup.sh && \
    echo 'exec node index.js' >> /startup.sh && \
    chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
