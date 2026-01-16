FROM ghost:5-alpine

# Copy package files and install dependencies
COPY package.json ./
RUN npm install

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

# Copy production config and custom entry point
COPY config.production.json /var/lib/ghost/config.production.json
COPY index.js /var/lib/ghost/index.js

# Set production environment
ENV NODE_ENV production

# Expose the port Ghost will listen on
EXPOSE 2368

# Use the custom index.js to start Ghost
CMD ["node", "index.js"]
