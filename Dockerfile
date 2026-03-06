FROM debian:bookworm

ADD kea-repo.gpg /
RUN apt update && \
    apt upgrade -y && \
    apt install -y gnupg ca-certificates && \
    apt-key add /kea-repo.gpg && \
    rm /kea-repo.gpg && \
    echo 'deb https://dl.cloudsmith.io/public/isc/kea-dev/deb/debian bullseye main' >> /etc/apt/sources.list && \
    apt update && \
    apt install -y \
        isc-kea-dhcp4-server \
        isc-kea-dhcp6-server \
        isc-kea-dhcp-ddns-server \
        isc-kea-ctrl-agent \
        isc-kea-admin \
        isc-kea-hooks \
        gettext \
        socat \
        iproute2
