FROM alpine:3.16

ARG PHP_VERSION=8

RUN apk update && apk upgrade && apk add --no-cache \ 
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-phar \
    wget \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    apk --no-cache add curl && \
    rm -f /var/cache/apk/*

WORKDIR /var/www

COPY ./requirements/wordpress/conf/wp-config-create.sh .
RUN chmod 766 wp-config-create.sh

# COPY ./requirements/wordpress/tools/setup.sh ./
# RUN sh setup.sh && rm setup.sh

COPY ./requirements/wordpress/conf/wp-setup.sh ./
RUN chmod 766 ./wp-setup.sh

ENTRYPOINT ["sh", "/var/www/wp-setup.sh"]

CMD ["/usr/sbin/php-fpm8", "-F"]