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

function inject() {
    if grep -q "csgo/addons/metamod" ${CS2DIR}/game/csgo/gameinfo.gi; then
        echo "Find metamod description in gameinfo.gi"
    else
        line_number=$(grep -n "csgo_lv" ${CS2DIR}/game/csgo/gameinfo.gi | cut -d: -f1)
        sed -i "${line_number}a\\\t\t\tGame csgo/addons/metamod" ${CS2DIR}/game/csgo/gameinfo.gi
        echo "Metamod description not find, insert into gameinfo.gi"
    fi
}

function copy() {
    if [ -d ${MODDIR}/cfg ]; then
        echo "Find cfg in mod dir, copy to cs2 cfg"
        cp -r ${MODDIR}/cfg/* ${CS2DIR}/game/csgo/cfg
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

check
link
if [ ${UPDATE} != "0" ]; then
    update
else
    echo "Skip update cs2 before start"
fi
inject
copy
start
