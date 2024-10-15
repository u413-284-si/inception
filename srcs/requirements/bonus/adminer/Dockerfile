FROM debian:bookworm

ARG UID=1000
ARG GID=1000

RUN groupadd -r -g $GID adminer && useradd -r -g adminer -u $UID admineruser

RUN apt update && apt upgrade && apt install -y \
        php-fpm \
        php-mysqli \
        curl

RUN mkdir -p /var/www/html \
    && chown -R admineruser:adminer /var/www/html /var/log \
    && chmod -R 755 /var/www/html /run/php/ \
    && touch /run/php/php8.2-fpm.pid \
    && chown -R admineruser:adminer /run/php/php8.2-fpm.pid

RUN curl -L https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -o adminer.php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.
COPY conf/index.php .
COPY tools/setup-adminer.sh .

RUN chmod +x setup-adminer.sh \
	&& mv setup-adminer.sh /usr/local/bin/

USER admineruser

ENTRYPOINT [ "setup-adminer.sh" ]

CMD ["php-fpm8.2", "-F"]
