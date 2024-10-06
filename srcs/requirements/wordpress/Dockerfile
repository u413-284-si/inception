FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		php-fpm \
		php-mysqli \
		curl

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.
COPY tools/setup-wordpress.sh .

RUN chmod +x setup-wordpress.sh

ENTRYPOINT [ "./setup-wordpress.sh" ]

# Start php-fpm in foreground with -F flag
CMD ["php-fpm8.2", "-F"]
