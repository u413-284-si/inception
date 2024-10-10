FROM debian:bookworm

ARG UID=1000
ARG GID=1000

RUN groupadd -r -g $GID mysql && useradd -r -g mysql -u $UID --home /var/lib/mysql/ mysqluser

RUN apt update && apt upgrade && apt install -y \
		mariadb-server

# Create dir for mysqld.sock to run in
RUN mkdir -p /run/mysqld \
		&& chown -R mysqluser:mysql /var/lib/mysql /run/mysqld /etc/mysql \
		&& chmod -R 755 /run/mysqld /etc/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/setup-mariadb.sh .

# Set execution rights on setup-script and make it globally available
RUN chmod +x setup-mariadb.sh \
	&& mv setup-mariadb.sh /usr/local/bin/

USER mysqluser

ENTRYPOINT [ "setup-mariadb.sh" ]
CMD [ "mariadbd" ]
