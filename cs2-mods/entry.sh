#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function check() {
    if [ -L "${CS2DIR}/game/csgo/addons" ];then
        rm "${CS2DIR}/game/csgo/addons"
    fi
}

function link() {
    mkdir -p ~/.steam/sdk64
    ln -sfT ${STEAMCMDDIR}/linux64/steamclient.so ~/.steam/sdk64/steamclient.so
    ln -s ${MODDIR}/addons/ ${CS2DIR}/game/csgo/addons
}

function update() {
    bash ${STEAMCMDDIR}/steamcmd.sh \
        +force_install_dir ${CS2DIR} \
        +login ${STEAMACCOUNT} ${STEAMPASSWORD} ${CODE} \
        +app_update ${CS2APPID} \
        +quit
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

check
link
if [ ${UPDATE} != "0" ]; then
    update
else
    echo "Skip update cs2 before start"
fi
start
