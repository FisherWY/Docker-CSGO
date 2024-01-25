FROM ubuntu:20.04

LABEL maintainer="wz2483156090@gmail.com"

ARG PUID=1000

ENV UPDATE "1"
ENV STEAMACCOUNT anonymous
ENV STEAMPASSWORD ""
ENV CODE ""

ENV USER steam
ENV CS2APP cs2
ENV CS2APPID 730
ENV IP 0.0.0.0
ENV PORT 27015
ENV GAMETYPE 0
ENV GAMEMODE 0
ENV MAPGROUP mg_active
ENV MAP de_dust2

ENV STEAMCMDDIR /steamcmd
ENV CS2DIR /cs2

RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6 \
        lib32gcc1 \
        lib32z1 \
        libsdl2-2.0-0:i386 \
        ca-certificates \
    && useradd -u "${PUID}" -m "${USER}" \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER ${USER}

VOLUME ${STEAMCMDDIR}
VOLUME ${CS2DIR}

COPY ./entry.sh /entry.sh

CMD ["bash", "/entry.sh"]

# Expose ports
EXPOSE ${PORT}/tcp \
	${PORT}/udp \
