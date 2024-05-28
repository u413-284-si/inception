FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		mariadb-server

CMD [ "mysqld_safe" ]
