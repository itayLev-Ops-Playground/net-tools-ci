FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        devscripts \
        debhelper \
        dpkg-dev \
        wget \
        fakeroot && \
    sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && \
    rm -rf /var/lib/apt/lists/*

COPY net-tools-docker.sh .

RUN chmod +x net-tools-docker.sh

CMD ["./net-tools-docker.sh"]
