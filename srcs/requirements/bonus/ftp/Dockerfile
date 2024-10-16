FROM debian:bookworm

ARG UID=1000
ARG GID=1000
ARG FTP_USER

RUN groupadd -r -g $GID ftp && useradd -r -g ftp -u $UID $FTP_USER

RUN apt update && apt upgrade && apt install -y \
        vsftpd

RUN mkdir -p /home/$FTP_USER/ftp /home/$FTP_USER/ftp/files /var/log /var/run/vsftpd \
        && chown -R $FTP_USER:ftp /home/$FTP_USER/ftp/files /var/log /var/run/vsftpd \
        && chmod -R 755 /var/log /var/run/vsftpd \
        && touch /var/log/vsftpd.log \
        && chown $FTP_USER:ftp /var/log/vsftpd.log

COPY conf/vsftpd.conf /etc/.
COPY tools/setup-ftp.sh .

RUN chmod +x setup-ftp.sh \
	&& mv setup-ftp.sh /usr/local/bin/ 

ENTRYPOINT [ "setup-ftp.sh" ]

CMD [ "vsftpd" ]
