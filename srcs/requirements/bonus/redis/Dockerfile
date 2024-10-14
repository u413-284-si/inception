FROM debian:bookworm

ARG UID=1000
ARG GID=1000

RUN groupadd -r -g $GID redis && useradd -r -g redis -u $UID redisuser

RUN apt update && apt upgrade && apt install -y \
		redis \
        sed

COPY conf/redis.conf /etc/redis/.
COPY ./tools/setup-redis.sh .

RUN chmod +x setup-redis.sh \
	&& mv setup-redis.sh /usr/local/bin/ \
    && chown -R redisuser:redis \
        /etc/redis \
        /var/lib/redis \
        /var/log/redis \
        /etc/redis/redis.conf

WORKDIR /etc/redis

USER redisuser

ENTRYPOINT [ "setup-redis.sh" ]
