#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function link() {
    mkdir -p ~/.steam/sdk64
    ln -sfT ${STEAMCMDDIR}/linux64/steamclient.so ~/.steam/sdk64/steamclient.so
}

function check() {
    # Remove symbol link
    if [ -L "${CS2DIR}/game/csgo/addons" ];then
        echo "Find symbol link for metamod, remove it"
        rm "${CS2DIR}/game/csgo/addons"
    fi
    # Remove desc in gameinfo.gi
    if grep -q "csgo/addons/metamod" ${CS2DIR}/game/csgo/gameinfo.gi; then
        echo "Find metamod description in gameinfo.gi, remove it"
        sed -i '/csgo\/addons\/metamod/d' ${CS2DIR}/game/csgo/gameinfo.gi
    fi
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

link
if [ ${UPDATE} != "0" ]; then
    update
else
    echo "Skip update cs2 before start"
fi
check
start
