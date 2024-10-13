FROM debian:bookworm

ARG UID=1000
ARG GID=1000

RUN groupadd -r -g $GID redis && useradd -r -g redis -u $UID redisuser

RUN apt update && apt upgrade && apt install -y \
		redis

COPY conf/redis.conf /etc/redis/.
COPY conf/sysctl.conf /etc/.
COPY ./tools/setup-redis.sh .

RUN chmod +x setup-redis.sh \
	&& mv setup-redis.sh /usr/local/bin/

USER redisuser

ENTRYPOINT [ "setup-redis.sh" ]

CMD [ "redis-server", "--protected-mode", "no" ]
