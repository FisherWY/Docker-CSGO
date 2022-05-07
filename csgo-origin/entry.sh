#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 检查软连接是否已经存在
function check() {
    if [ -L "${CSGODIR}/csgo/addons" ];then
        rm "${CSGODIR}/csgo/addons"
    fi
}

# 检查CSGO服务器更新
function update() {
    bash ${STEAMCMDDIR}/steamcmd.sh \
        +force_install_dir ${CSGODIR} \
        +login anonymous \
        +app_update ${CSGOAPPID} \
        +quit
}

# 启动服务器
function start() {
    ${CSGODIR}/srcds_run \
        -game ${CSGOAPP} \
        -console \
        -usercon \
        -port ${PORT} \
        -ip ${IP} \
        -tickrate ${TICKRATE} \
        +game_type ${GAMETYPE} \
        +game_mode ${GAMEMODE} \
        +mapgroup ${MAPGRAOUP} \
        +map ${MAP}
}

# 执行流程
check
update
start
