#!/bin/bash
set -e
set -o pipefail

# Logging functions
log() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] $1"
}

error() {
    echo "[`date +'%Y-%m-%d %H:%M:%S'`] ERROR: $1" >&2
    exit 1
}

log "Starting vsftpd for setup"
service vsftpd start

log "Creating FTP user"
FTP_PWD="$(cat $FTP_PASSWORD)"
echo "$FTP_USER:$FTP_PWD" | /usr/sbin/chpasswd &> /dev/null
echo "$FTP_USER" | tee -a /etc/vsftpd.userlist &> /dev/null

echo -e "\nlocal_root=/home/$FTP_USER/ftp\n
# Drop privileges to this user after binding ports and setup
nopriv_user=$FTP_USER" >> /etc/vsftpd.conf

log "FTP user setup complete, stopping vsftpd"
service vsftpd stop

log "Starting vsftpd in foreground"
exec $@
