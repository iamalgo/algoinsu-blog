FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config template
COPY config.production.json /tmp/config.template.json

# Create startup script to configure Ghost via Environment Variables and theme setting
RUN cat > /startup.sh <<EOF
#!/bin/sh
set -e
echo "Cleaning up old config files..."
rm -f /var/lib/ghost/config.production.json
rm -f /var/lib/ghost/config.development.json
# Create config file with the theme setting
echo '{"theme":"algoinsu"}' > /var/lib/ghost/config.production.json
cp /var/lib/ghost/config.production.json /var/lib/ghost/config.development.json
# Set Environment Variables
export url="https://\$RAILWAY_PUBLIC_DOMAIN"
export process=local
export server__host=0.0.0.0
export server__port=2368
export paths__contentPath=/var/lib/ghost/content
export database__client=sqlite3
export database__connection__filename=/var/lib/ghost/content/ghost.db
export NODE_ENV=development
mkdir -p /var/lib/ghost/content
echo "Starting Ghost..."
exec node current/index.js 2>&1
EOF
RUN chmod +x /startup.sh

WORKDIR /var/lib/ghost

EXPOSE 2368

CMD ["/startup.sh"]
