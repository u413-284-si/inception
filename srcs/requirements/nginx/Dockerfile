FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y nginx

COPY conf/default /etc/nginx/sites-available/.

# run nginx in the foreground and apply this as a global directive
# ensuring it applies to the entire nginx process including spawned
# worker processes
CMD ["nginx", "-g", "daemon off;"]
