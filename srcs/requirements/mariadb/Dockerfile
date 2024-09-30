FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
		mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY conf/init.sql /etc/mysql/init.sql
COPY tools/script.sh .

# create dir for mysqld.sock to run in
RUN mkdir /run/mysqld && chmod +x script.sh

CMD [ "./script.sh" ]
