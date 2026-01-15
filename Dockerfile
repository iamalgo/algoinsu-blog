FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config
COPY config.production.json /var/lib/ghost/config.production.json

# Expose the default Ghost port
EXPOSE 2368
