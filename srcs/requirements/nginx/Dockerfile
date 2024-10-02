FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		nginx \
		ssl-cert

COPY conf/default /etc/nginx/sites-available/.
COPY conf/nginx.conf /etc/nginx/.
COPY tools/setup-nginx.sh .

RUN chmod +x setup-nginx.sh

CMD ["./setup-nginx.sh"]
