FROM ubuntu:20.04

LABEL maintainer="wz2483156090@gmail.com"

ARG PUID=1000

ENV USER steam
ENV CSGOAPPID 740
ENV STEAMCMDDIR /steamcmd
ENV CSGODIR /csgo-server
ENV STEAMACCOUNT "YOUR_STEAM_ACCOUNT_FROM_CSGO_DEVS"
ENV SERVER_HOSTNAME "CSGO_DOCKER_SERVER_BY_FISHER"
ENV RCON_PASSWORD "12345678"
ENV SV_PASSWORD "12345678"

RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6 \
        lib32gcc1 \
        lib32z1 \
        libsdl2-2.0-0:i386 \
        wget \
        ca-certificates \
    && useradd -u "${PUID}" -m "${USER}" \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER ${USER}

VOLUME ${STEAMCMDDIR}
VOLUME ${CSGODIR}

COPY ./entry.sh /entry.sh

CMD ["bash", "/entry.sh"]
