#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 检查软连接是否已经存在
function check() {
    if [ -L "${CSGODIR}/csgo/addons" ];then
        rm "${CSGODIR}/csgo/addons"
    fi
}

# 将当前插件连接到CSGO服务器文件夹上
function link() {
    ln -s ${MODDIR}/addons/ ${CSGODIR}/csgo/addons
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
    if [ "${AUTHKEY}" == "NONE" ];then
        ${CSGODIR}/srcds_run \
            -game ${CSGOAPP} \
            -console \
            -usercon \
            -port ${PORT} \
            -ip ${IP} \
            -tickrate ${TICKRATE} \
            +mapgroup ${MAPGRAOUP} \
            +map ${MAP}
    else
        ${CSGODIR}/srcds_run \
            -game ${CSGOAPP} \
            -console \
            -usercon \
            -port ${PORT} \
            -ip ${IP} \
            -tickrate ${TICKRATE} \
            +host_workshop_collection ${MAPGROUP} \
            +workshop_start_map ${MAP} \
            -authkey ${AUTHKEY}
    fi
}

# 执行流程
check
link
update
start
