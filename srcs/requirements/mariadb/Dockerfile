FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/setup-mariadb.sh .

# Create dir for mysqld.sock to run in
# Set execution rights on setup-script and make it globally available
RUN mkdir /run/mysqld \
	&& chmod +x setup-mariadb.sh \
	&& mv setup-mariadb.sh /usr/local/bin/

ENTRYPOINT [ "setup-mariadb.sh" ]
CMD [ "mariadbd" ]
