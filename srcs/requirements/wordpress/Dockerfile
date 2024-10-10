FROM debian:bookworm

ARG UID=1000
ARG GID=1000

RUN groupadd -r -g $GID wp && useradd -r -g wp -u $UID wpuser

RUN apt update && apt upgrade && apt install -y \
		php-fpm \
		php-mysqli \
		curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html /home/wpuser/.wp-cli/cache/ \
	&& chown -R wpuser:wp /var/www/html /var/log /home/wpuser/.wp-cli/cache/ \
	&& chmod -R 775 /var/www/html /run/php/ \
	&& touch /run/php/php8.2-fpm.pid \
	&& chown -R wpuser:wp /run/php/php8.2-fpm.pid

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.
COPY tools/setup-wordpress.sh .

RUN chmod +x setup-wordpress.sh \
	&& mv setup-wordpress.sh /usr/local/bin/

WORKDIR /var/www/html/

USER wpuser

ENTRYPOINT [ "setup-wordpress.sh" ]

# Start php-fpm in foreground with -F flag
CMD ["php-fpm8.2", "-F"]
