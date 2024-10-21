# Use an Ubuntu base image with systemd support
FROM ubuntu:latest

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    systemd \
    tmate \
    nginx \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories for systemd
RUN mkdir -p /var/run/systemd && \
    mkdir -p /var/www/html

# Start tmate in the background and write the session details to index.html
RUN tmate -F | tee /var/www/html/index.html &

# Replace the default Nginx config with a basic one
RUN echo 'server { listen 80; location / { root /var/www/html; try_files $uri $uri/ =404; } }' > /etc/nginx/sites-available/default

# Expose port 80 for the web server
EXPOSE 80

# Start systemd as the init system
CMD ["/lib/systemd/systemd"]
