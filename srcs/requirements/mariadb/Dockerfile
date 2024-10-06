FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/setup-mariadb.sh .

# create dir for mysqld.sock to run in
RUN mkdir /run/mysqld && chmod +x setup-mariadb.sh

ENTRYPOINT [ "./setup-mariadb.sh" ]
CMD [ "mariadbd" ]
