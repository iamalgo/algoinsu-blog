FROM ghost:5-alpine

# Copy custom theme
COPY content/themes/algoinsu /var/lib/ghost/content/themes/algoinsu

WORKDIR /var/lib/ghost

EXPOSE 2368
