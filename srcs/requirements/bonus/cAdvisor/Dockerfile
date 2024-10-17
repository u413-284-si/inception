FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y \
        wget

RUN wget -O cadvisor https://github.com/google/cadvisor/releases/download/v0.50.0/cadvisor-v0.50.0-linux-amd64 \
    && chmod +x cadvisor \
    && mv cadvisor /usr/local/bin/ 

COPY tools/setup-cadvisor.sh .

RUN chmod +x setup-cadvisor.sh \
    && mv setup-cadvisor.sh /usr/local/bin/

ENTRYPOINT [ "setup-cadvisor.sh" ]

CMD [ "cadvisor" ]
