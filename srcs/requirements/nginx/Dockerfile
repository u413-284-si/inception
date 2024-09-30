FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y nginx

COPY conf/default /etc/nginx/sites-available/.

# -g: pass global directives to the nginx process
# daemon off: run nginx in the foreground
# 
# Passes as a global directive ensuring it applies to the entire nginx process including spawned
# worker processes. It is necessary when running Nginx inside a Docker
# container because Docker expects the main process (in this case, Nginx)
# to stay in the foreground. If Nginx daemonizes itself, the container would exit
# because Docker thinks the process has finished.
CMD ["nginx", "-g", "daemon off;"]
