#!/bin/bash

# Determine the home directory
HOME_DIR="$HOME"

# Define the Docker volume name (assumes 'nextcloud_sslcerts' volume exists)
VOLUME_NAME="nextcloud_sslcerts"

# Get the Docker volume path
DOCKER_VOLUME_PATH=$(docker volume inspect "$VOLUME_NAME" --format '{{ .Mountpoint }}')

# Check if the Docker volume path was obtained successfully
if [ -z "$DOCKER_VOLUME_PATH" ]; then
    echo "Error: Docker volume '$VOLUME_NAME' not found. Please create the volume before running this script."
    exit 1
fi

# Define directories and files
CERTS_DIR="$HOME_DIR/nextcloud/certs"
NGINX_CONF="$HOME_DIR/nextcloud/nginx.conf"
DOCKERFILE_APP="$HOME_DIR/nextcloud/Dockerfile.app"
DB_ENV="$HOME_DIR/nextcloud/db.env"
ENV_FILE="$HOME_DIR/nextcloud/.env"
DOCKER_VOLUME_CERTS_DIR="$DOCKER_VOLUME_PATH"

# Create directories if they do not exist
mkdir -p "$CERTS_DIR"
mkdir -p "$HOME_DIR/nextcloud"
mkdir -p "$DOCKER_VOLUME_CERTS_DIR"

# Generate SSL/TLS Certificates and Diffie-Hellman Parameters
cd "$CERTS_DIR" || exit

# Generate RSA private key if it doesn't already exist
if [ ! -f "mycloud.example.com.key" ]; then
    openssl genrsa -out mycloud.example.com.key 2048
    echo "Generated RSA private key: mycloud.example.com.key"
else
    echo "RSA private key already exists: mycloud.example.com.key"
fi

# Generate self-signed CA certificate if it doesn't already exist
if [ ! -f "myCA.pem" ]; then
    openssl req -x509 -new -nodes -key mycloud.example.com.key -sha256 -days 365 -out myCA.pem -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=MyCA"
    echo "Generated self-signed CA certificate: myCA.pem"
else
    echo "Self-signed CA certificate already exists: myCA.pem"
fi

# Generate Certificate Signing Request if it doesn't already exist
if [ ! -f "mycloud.example.com.csr" ]; then
    openssl req -new -key mycloud.example.com.key -out mycloud.example.com.csr -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=mycloud.example.com"
    echo "Generated Certificate Signing Request: mycloud.example.com.csr"
else
    echo "Certificate Signing Request already exists: mycloud.example.com.csr"
fi

# Sign the certificate with the CA certificate if it doesn't already exist
if [ ! -f "mycloud.example.com.crt" ]; then
    openssl x509 -req -in mycloud.example.com.csr -CA myCA.pem -CAkey mycloud.example.com.key -CAcreateserial -out mycloud.example.com.crt -days 365 -sha256
    echo "Signed certificate with CA: mycloud.example.com.crt"
else
    echo "Signed certificate already exists: mycloud.example.com.crt"
fi

# Generate Diffie-Hellman parameters if it doesn't already exist
if [ ! -f "dhparam.pem" ]; then
    openssl dhparam -out dhparam.pem 2048
    echo "Generated Diffie-Hellman parameters: dhparam.pem"
else
    echo "Diffie-Hellman parameters already exist: dhparam.pem"
fi

# Create nginx.conf file if it doesn't already exist
if [ ! -f "$NGINX_CONF" ]; then
    cat <<EOF > "$NGINX_CONF"
worker_processes auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  10024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;

    server_tokens   off;

    keepalive_timeout  65;

    gzip on;
    gzip_vary on;
    gzip_comp_level 4;
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

    upstream php-handler {
        server app:9000;
    }

    server {
        listen 80;

        client_max_body_size 512M;
        fastcgi_buffers 64 4K;

        gzip on;
        gzip_vary on;
        gzip_comp_level 4;
        gzip_min_length 256;
        gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
        gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

        add_header Referrer-Policy                      "no-referrer"       always;
        add_header X-Content-Type-Options               "nosniff"           always;
        add_header X-Download-Options                   "noopen"            always;
        add_header X-Frame-Options                      "SAMEORIGIN"        always;
        add_header X-Permitted-Cross-Domain-Policies    "none"              always;
        add_header X-Robots-Tag                         "noindex, nofollow" always;
        add_header X-XSS-Protection                     "1; mode=block"     always;

        fastcgi_hide_header X-Powered-By;

        root /var/www/html;

        index index.php index.html /index.php\$request_uri;

        location = / {
            if ( \$http_user_agent ~ ^DavClnt ) {
                return 302 /remote.php/webdav/\$is_args\$args;
            }
        }

        location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
        }

        location ^~ /.well-known {
            location = /.well-known/carddav { return 301 /remote.php/dav/; }
            location = /.well-known/caldav  { return 301 /remote.php/dav/; }

            location /.well-known/acme-challenge    { try_files \$uri \$uri/ =404; }
            location /.well-known/pki-validation    { try_files \$uri \$uri/ =404; }

            return 301 /index.php\$request_uri;
        }

        location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)  { return 404; }
        location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }

        location ~ \.php(?:$|/) {
            rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy) /index.php\$request_uri;

            fastcgi_split_path_info ^(.+?\.php)(/.*)$;
            set \$path_info \$fastcgi_path_info;

            try_files \$fastcgi_script_name =404;

            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            fastcgi_param PATH_INFO \$path_info;

            fastcgi_param modHeadersAvailable true;
            fastcgi_param front_controller_active true;
            fastcgi_pass php-handler;

            fastcgi_intercept_errors on;
            fastcgi_request_buffering off;
        }

        location ~ \.(?:css|js|svg|gif)$ {
            try_files \$uri /index.php\$request_uri;
            expires 6M;
            access_log off;
        }

        location ~ \.woff2?$ {
            try_files \$uri /index.php\$request_uri;
            expires 7d;
            access_log off;
        }

        location /remote {
            return 301 /remote.php\$request_uri;
        }

        location / {
            try_files \$uri \$uri/ /index.php\$request_uri;
        }
    }

    server {
        listen 443 ssl;

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_dhparam /etc/nginx/ssl/dhparam.pem;

        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;

        client_max_body_size 512M;
        fastcgi_buffers 64 4K;

        root /var/www/html;

        index index.php index.html /index.php\$request_uri;

        location = / {
            if ( \$http_user_agent ~ ^DavClnt ) {
                return 302 /remote.php/webdav/\$is_args\$args;
            }
        }

        location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
        }

        location ^~ /.well-known {
            location = /.well-known/carddav { return 301 /remote.php/dav/; }
            location = /.well-known/caldav  { return 301 /remote.php/dav/; }

            location /.well-known/acme-challenge    { try_files \$uri \$uri/ =404; }
            location /.well-known/pki-validation    { try_files \$uri \$uri/ =404; }

            return 301 /index.php\$request_uri;
        }

        location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)  { return 404; }
        location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }

        location ~ \.php(?:$|/) {
            rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy) /index.php\$request_uri;

            fastcgi_split_path_info ^(.+?\.php)(/.*)$;
            set \$path_info \$fastcgi_path_info;

            try_files \$fastcgi_script_name =404;

            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            fastcgi_param PATH_INFO \$path_info;

            fastcgi_param modHeadersAvailable true;
            fastcgi_param front_controller_active true;
            fastcgi_pass php-handler;

            fastcgi_intercept_errors on;
            fastcgi_request_buffering off;
        }

        location ~ \.(?:css|js|svg|gif)$ {
            try_files \$uri /index.php\$request_uri;
            expires 6M;
            access_log off;
        }

        location ~ \.woff2?$ {
            try_files \$uri /index.php\$request_uri;
            expires 7d;
            access_log off;
        }

        location /remote {
            return 301 /remote.php\$request_uri;
        }

        location / {
            try_files \$uri \$uri/ /index.php\$request_uri;
        }
    }
}
EOF
    echo "Created nginx configuration file: $NGINX_CONF"
else
    echo "nginx configuration file already exists: $NGINX_CONF"
fi

# Create Dockerfile.app file if it doesn't already exist
if [ ! -f "$DOCKERFILE_APP" ]; then
    cat <<EOF > "$DOCKERFILE_APP"
# Use the official Nextcloud image as a base image
FROM nextcloud:stable-fpm-alpine

# Install dependencies, including necessary development libraries
RUN apk update && \
    apk add --no-cache \
    build-base \
    cmake \
    git \
    imagemagick-dev \
    ffmpeg \
    nodejs \
    npm \
    util-linux \
    git \
    g++ \
    ghostscript \
    libx11-dev \
    sudo \
    nano \
    samba-client \
    bzip2-dev \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    freetype-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg --with-freetype --with-webp && \
    docker-php-ext-install gd mysqli pdo pdo_mysql opcache bz2

# Install imagick using pecl only if it's not already installed
RUN if ! pecl list | grep -q imagick; then \
        pecl install imagick && \
        docker-php-ext-enable imagick; \
    fi

# Set environment variables
ENV NODE_PATH /usr/bin/node
ENV NICE_CMD /usr/bin/nice

# Install dlib and pdlib
RUN git clone https://github.com/davisking/dlib.git && \
    cd dlib/dlib && mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=ON .. && make && make install

RUN git clone https://github.com/goodspb/pdlib.git /usr/src/php/ext/pdlib && \
    docker-php-ext-install pdlib

# Cleanup unnecessary packages
RUN apk del build-base cmake git && \
    rm -rf /var/cache/apk/*
EOF
    echo "Created Dockerfile.app: $DOCKERFILE_APP"
else
    echo "Dockerfile.app already exists: $DOCKERFILE_APP"
fi

# Create db.env file if it doesn't already exist
if [ ! -f "$DB_ENV" ]; then
    cat <<EOF > "$DB_ENV"
POSTGRES_PASSWORD=securepassword
POSTGRES_DB=nextcloud
POSTGRES_USER=nextcloud
EOF
    echo "Created db.env file: $DB_ENV"
else
    echo "db.env file already exists: $DB_ENV"
fi

# Create .env file if it doesn't already exist
if [ ! -f "$ENV_FILE" ]; then
    cat <<EOF > "$ENV_FILE"
POSTGRES_VERSION=14-alpine
REDIS_VERSION=6.2-alpine
NGINX_VERSION=alpine
REDIS_PORT=6379
NGINX_PORT=8443
NEXTCLOUD_EXTDATA=/mnt/ad/nextcloud
PHP_MEMORY_LIMIT=2048M
EOF
    echo "Created .env file: $ENV_FILE"
else
    echo ".env file already exists: $ENV_FILE"
fi

# Copy SSL/TLS certificate files if they do not already exist
if [ ! -f "$DOCKER_VOLUME_CERTS_DIR/key.pem" ]; then
    cp "$CERTS_DIR/mycloud.example.com.key" "$DOCKER_VOLUME_CERTS_DIR/key.pem"
    echo "Copied key.pem to Docker volume path: $DOCKER_VOLUME_CERTS_DIR/key.pem"
else
    echo "key.pem already exists in Docker volume path: $DOCKER_VOLUME_CERTS_DIR/key.pem"
fi

if [ ! -f "$DOCKER_VOLUME_CERTS_DIR/cert.pem" ]; then
    cp "$CERTS_DIR/myCA.pem" "$DOCKER_VOLUME_CERTS_DIR/cert.pem"
    echo "Copied cert.pem to Docker volume path: $DOCKER_VOLUME_CERTS_DIR/cert.pem"
else
    echo "cert.pem already exists in Docker volume path: $DOCKER_VOLUME_CERTS_DIR/cert.pem"
fi

if [ ! -f "$DOCKER_VOLUME_CERTS_DIR/dhparam.pem" ]; then
    cp "$CERTS_DIR/dhparam.pem" "$DOCKER_VOLUME_CERTS_DIR/dhparam.pem"
    echo "Copied dhparam.pem to Docker volume path: $DOCKER_VOLUME_CERTS_DIR/dhparam.pem"
else
    echo "dhparam.pem already exists in Docker volume path: $DOCKER_VOLUME_CERTS_DIR/dhparam.pem"
fi
