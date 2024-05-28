FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		php-fpm \
		php-mysqli

CMD ["php-fpm8.2", "-F"]
