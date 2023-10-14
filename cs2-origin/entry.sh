#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function link() {
    mkdir -p ~/.steam/sdk64
    ln -sfT ${STEAMCMDDIR}/linux64/steamclient.so ~/.steam/sdk64/steamclient.so
}

function start() {
    ${CS2DIR}/game/bin/linuxsteamrt64/cs2 \
        -dedicated \
        -ip ${IP} \
        -port ${PORT} \
        -console \
        -usercon \
        +game_type ${GAMETYPE} \
        +game_mode ${GAMEMODE} \
        +mapgroup ${MAPGRAOUP} \
        +map ${MAP}
}

link
start
