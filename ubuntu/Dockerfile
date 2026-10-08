FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build

COPY net-tools-docker.sh .

RUN chmod +x net-tools-docker.sh

CMD ["./net-tools-docker.sh"]
