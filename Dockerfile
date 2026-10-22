
FROM ubuntu:26.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends bind9 bind9utils && \
    rm -rf /var/lib/apt/lists/*
COPY named.conf.options /etc/bind/
COPY named.conf.local /etc/bind/
EXPOSE 53/tcp 53/udp
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
