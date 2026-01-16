FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Set production environment
ENV NODE_ENV production

# Expose the default Ghost port
EXPOSE 2368
