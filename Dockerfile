FROM debian:bullseye

ADD kea-repo.gpg /
RUN apt update && \
    apt upgrade -y && \
    apt install -y gnupg ca-certificates && \
    apt-key add /kea-repo.gpg && \
    rm /kea-repo.gpg && \
    echo 'deb https://dl.cloudsmith.io/public/isc/kea-2-0/deb/debian bullseye main' >> /etc/apt/sources.list && \
    apt update && \
    apt install -y isc-kea-dhcp4-server isc-kea-dhcp-ddns-server isc-kea-ctrl-agent isc-kea-admin

ADD conf/kea-ctrl-agent.conf /etc/kea/kea-ctrl-agent.conf
ADD conf/kea-dhcp4.conf.env /etc/kea/kea-dhcp4.conf.env
ADD bootstrap.sh /bootstrap.sh

ENTRYPOINT ["/bootstrap.sh"]
