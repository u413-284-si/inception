FROM debian:bookworm

ARG UID=1000
ARG GID=1000

RUN groupadd -r -g $GID nginx && useradd -r -g nginx -u $UID nginxuser

RUN apt update && apt upgrade && apt install -y \
		nginx \
		gnutls-bin \
		ssl-cert

RUN mkdir -p /var/www/html/ /etc/nginx/ /var/cache/nginx /var/log/nginx /var/lib/nginx \
		&& chown -R nginxuser:nginx /var/www/html/ /etc/nginx/ /var/cache/nginx /var/log/nginx /var/lib/nginx \
		&& chmod -R 755 /etc/nginx/conf.d \
		&& touch /run/nginx.pid \
		&& chown -R nginxuser:nginx /run/nginx.pid
	
COPY conf/default /etc/nginx/sites-available/.
COPY conf/nginx.conf /etc/nginx/.
COPY tools/setup-nginx.sh .

RUN chmod +x setup-nginx.sh \
	&& mv setup-nginx.sh /usr/local/bin/

USER nginxuser

ENTRYPOINT [ "setup-nginx.sh" ]
