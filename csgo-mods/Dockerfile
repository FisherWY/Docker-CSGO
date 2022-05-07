FROM ubuntu:20.04

LABEL maintainer="wz2483156090@gmail.com"

ARG PUID=1000

ENV USER steam
ENV CSGOAPP csgo
ENV CSGOAPPID 740
ENV IP 0.0.0.0
ENV PORT 27015
ENV TICKRATE 128
ENV MAPGROUP mg_active
ENV MAP de_dust2
ENV AUTHKEY NONE

ENV STEAMCMDDIR /steamcmd
ENV CSGODIR /csgo-server
ENV MODDIR /mod

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
    && ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER ${USER}

VOLUME ${STEAMCMDDIR}
VOLUME ${CSGODIR}
VOLUME ${MODDIR}

COPY ./entry.sh /entry.sh

CMD ["bash", "/entry.sh"]

# Expose ports
EXPOSE ${PORT}/tcp \
	${PORT}/udp \
