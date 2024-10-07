FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		php-fpm \
		php-mysqli \
		curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.
COPY tools/setup-wordpress.sh .

RUN chmod +x setup-wordpress.sh \
	&& mv setup-wordpress.sh /usr/local/bin/

WORKDIR /var/www/html/

ENTRYPOINT [ "setup-wordpress.sh" ]

# Start php-fpm in foreground with -F flag
CMD ["php-fpm8.2", "-F"]
