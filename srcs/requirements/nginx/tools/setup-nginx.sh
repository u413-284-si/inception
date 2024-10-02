#!/bin/bash

# Create a Configuration Snippet Pointing to the SSL Key and Certificate
touch /etc/nginx/snippets/self-signed.conf
echo "ssl_certificate /run/secrets/site.crt;
ssl_certificate_key /run/secrets/site.key;" > /etc/nginx/snippets/self-signed.conf

# Create a Configuration Snippet with Strong Encryption Settings
touch /etc/nginx/snippets/ssl-params.conf
echo "ssl_protocols TLSv1.3;
ssl_prefer_server_ciphers on;
ssl_ciphers EECDH+AESGCM:EDH+AESGCM;
ssl_ecdh_curve secp384r1;
ssl_session_timeout  10m;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
# Disable strict transport security for now. You can uncomment the following
# line if you understand the implications.
# add_header Strict-Transport-Security \"max-age=63072000; includeSubDomains; preload\";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection \"1; mode=block\";" > /etc/nginx/snippets/ssl-params.conf

# Pass as a global directive ensuring it applies to the entire nginx process including spawned
# worker processes. It is necessary when running Nginx inside a Docker
# container because Docker expects the main process (in this case, Nginx)
# to stay in the foreground. If Nginx daemonizes itself, the container would exit
# because Docker thinks the process has finished.
#
# -g: pass global directives to the nginx process
# daemon off: run nginx in the foreground
nginx -g 'daemon off;'