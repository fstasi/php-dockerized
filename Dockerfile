################################################################################
# Base image
################################################################################

FROM nginx

################################################################################
# Build instructions
################################################################################

ENV TERM xterm

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Add Backports (needed for certbot)

RUN sh -c "echo -n 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list.d/backports.list"

# Install packages
RUN apt-get update && apt-get install -my \
  nano \
  openssl \
  supervisor \
  curl \
  wget \
  php5-curl \
  php5-fpm \
  php5-gd \
  php5-memcached \
  php5-mysql \
  php5-mcrypt \
  php5-sqlite \
  php5-xdebug \
  php-apc \
  certbot -t jessie-backports

# Ensure that PHP5 FPM is run as root.
RUN sed -i "s/user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php5/fpm/pool.d/www.conf

# Pass all docker environment
RUN sed -i '/^;clear_env = no/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Get access to FPM-ping page /ping
RUN sed -i '/^;ping\.path/s/^;//' /etc/php5/fpm/pool.d/www.conf
# Get access to FPM_Status page /status
RUN sed -i '/^;pm\.status_path/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Prevent PHP Warning: 'xdebug' already loaded.
# XDebug loaded with the core
RUN sed -i '/.*xdebug.so$/s/^/;/' /etc/php5/mods-available/xdebug.ini

# Install HHVM
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list
RUN apt-get update && apt-get install -y hhvm

ARG adminuser
ARG adminpass

# Generate the password
RUN sh -c "echo -n '$adminuser:' >> /etc/nginx/.htpasswd"
RUN sh -c "openssl passwd -apr1 $adminpass >> /etc/nginx/.htpasswd"

# Add configuration files
COPY conf/nginx.conf /etc/nginx/
COPY conf/default.vhost /etc/nginx/sites-enabled/default.vhost
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini

# COPY ssl template certificate
COPY ssl /etc/nginx/ssl

################################################################################
# Volumes
################################################################################

#VOLUME ["/var/www"]

################################################################################
# Ports
################################################################################

EXPOSE 80 8080 443

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT supervisord -c /etc/supervisor/conf.d/supervisord.conf
