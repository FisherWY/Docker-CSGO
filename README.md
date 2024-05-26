# Docker-CSGO
CSGO服务器Docker镜像，使用一份游戏服务器本体文件+多份Mod文件，通过软链接和容器化的方式实现不同模式的快速切换  
Dockerfile参考了[CM2Walki/CSGO](https://github.com/CM2Walki/CSGO)的写法

## 教程
1. 图文教程: 个人博客点[这里](https://fisherwy.github.io/)和B站专栏点[这里](https://www.bilibili.com/read/cv16555775)
2. 视频教程: B站视频点[这里](https://www.bilibili.com/video/BV15Z4y1t7F3/)

## 镜像描述
- `docker-csgo:installer`: 服务器安装器，通过将文件夹挂载到容器中，完成Steamcmd和CSGO服务器的安装
- `docker-csgo:origin`: 无Mod版本服务器，与官方的服务器相同
- `docker-csgo:mods`: 有Mod版本服务器，可以通过挂载不同的Mod文件夹运行不同插件的服务器

## 使用环境
- 在Ubuntu 20.04.4 LTS上测试无问题，其他系统未知
- 依赖: `docker`和`docker-compose`，参考官网文档安装

## 使用方式
### 1. 拉取服务器安装器镜像
如果已经安装Steamcmd和CSGO服务器，则可以跳过第1步和第2步  

拉取安装器镜像
```bash
sudo docker pull registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:installer
```

### 2. 创建和启动安装器容器，安装Steamcmd和CSGO服务器
容器需要挂载Steamcmd和CSGO服务器的文件夹，同时可以将以下参数写入`server.cfg`文件:
- `STEAMACCOUNT`: Steam游戏服务器令牌，没有此令牌，启动的服务器无法在服务器列表中可见，可以从[这里](https://steamcommunity.com/dev/managegameservers)生成令牌
- `SERVER_HOSTNAME`: CSGO服务器名称，该名称显示在服务器列表中
- `RCON_PASSWORD`: CSGO服务器远程控制台连接密码，默认为`12345678`
- `SV_PASSWORD`: CSGO服务器房间密码，默认为`12345678`

创建用于储存Steamcmd和CSGO服务器文件的挂载文件夹，文件夹路径和名称可以自定义（后面配置需要修改）
```bash
cd ~
mkdir steamcmd
mkdir csgo-server
```

创建容器有两种方式，分别是命令行和`docker-compose`，看个人喜好和使用习惯选择不同的方式，其中的参数和挂载文件夹路径**根据自己需要做出改变**  

命令行创建和启动容器
```bash
sudo docker run -d --name=csgo-installer \
     -v `pwd`/steamcmd:/steamcmd \
     -v `pwd`/csgo-server:/csgo-server \
     -e STEAMACCOUNT=xxxxxxxxxx \
     -e SERVER_HOSTNAME=CSGOSERVER \
     -e RCON_PASSWORD=12345678 \
     -e SV_PASSWORD=12345678 \
     registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:installer
```

`docker-compose`创建，使用命令之前需要先创建一个YAML配置文件
```yaml
# 文件名: docker-csgo-installer.yaml
# docker-csgo:installer 的示例配置文件
version: '3'
services:
  csgo-installer:
    container_name: csgo-installer
    image: registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:installer
    volumes:
      - /home/fisher/steamcmd:/steamcmd # 冒号前的挂载路径需要根据自己的配置改变，可以使用pwd命令查看当前路径
      - /home/fisher/csgo-server:/csgo-server   # 挂载路径配置同上
    environment:
      - STEAMACCOUNT=xxxxxxxxxx
      - SERVER_HOSTNAME=CSGOSERVER
      - RCON_PASSWORD=12345678
      - SV_PASSWORD=12345678
```
使用`docker-compose`创建和启动容器
```bash
sudo docker-compose -f docker-csgo-installer.yaml up -d
```

### 3. 创建和启动原版CSGO服务器容器
如果需要启动带Mod的CSGO服务器，直接跳到第4步  

拉取原版CSGO服务器镜像
```bash
sudo docker pull registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:origin
```

创建容器的方式同样有命令行和`docker-compose`，其中的参数和挂载文件夹路径**根据自己需要做出改变**，可以自定义的启动参数有以下几种:
- `PORT`: 服务器端口，默认为`27015`，本样例中没有设置该参数(懂的可自行修改，同时需要设置容器的端口映射)
- `TICKRATE`: 服务器的Tickrate，可以设置为`64`或`128`，默认为`128`
- `GAMETYPE`: 游戏类型和游戏模式设置(休闲、竞技、死斗)，默认为`0`，想要启动其他模式可以参考[这里](https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive_Dedicated_Servers#Starting_the_Server)
- `GAMEMODE`: 游戏类型和游戏模式设置(休闲、竞技、死斗)，默认为`0`，想要启动其他模式可以参考[这里](https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive_Dedicated_Servers#Starting_the_Server)
- `MAPGROUP`: 游戏地图组设置，默认为`mg_active`
- `MAP`: 游戏地图设置，默认为`de_dust2`

命令行创建和启动容器
```bash
sudo docker run -d --name=csgo-origin -net=host \
     -v `pwd`/steamcmd:/steamcmd \
     -v `pwd`/csgo-server:/csgo-server \
     -e TICKRATE=128 \
     -e GAMETYPE=0 \
     -e GAMEMODE=0 \
     -e MAPGROUP=mg_active \
     -e MAP=de_mirage \
     registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:origin
```

`docker-compose`创建，需要先创建一个YAML配置文件
```yaml
# 文件名: docker-csgo-origin.yaml
# docker-csgo:origin 的示例配置文件
version: '3'
services:
  csgo-origin:
    container_name: csgo-origin
    restart: always
    image: registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:origin
    network_mode: host
    volumes:
      - /home/fisher/steamcmd:/steamcmd # 冒号前的挂载路径需要根据自己的配置改变，可以使用pwd命令查看当前路径
      - /home/fisher/csgo-server:/csgo-server   # 同上
    environment:
      - TICKRATE=128
      - GAMETYPE=0
      - GAMEMODE=0
      - MAPGROUP=mg_active
      - MAP=de_mirage
```
使用`docker-compose`创建和启动容器
```bash
sudo docker-compose -f docker-csgo-origin.yaml up -d
```

### 4. 创建和启动带Mod的CSGO服务器容器
在此以[Multi-1v1](https://github.com/splewis/csgo-multi-1v1)插件为例子，同时使用到了插件和创意工坊地图，在使用创意工坊地图之前，首先要去获取一个Steam网页API密钥，点击[这里](http://steamcommunity.com/dev/apikey)去获取

拉取有Mod版本服务器镜像
```bash
sudo docker pull registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:mods
```

创建插件文件夹，下载所需要的插件，分别是: mmsource, sourcemod和multi-1v1
```bash
cd ~
mkdir 1v1
wget --no-check-certificate -O ./1v1/mmsource.tar.gz https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1145-linux.tar.gz
wget --no-check-certificate -O ./1v1/sourcemod.tar.gz https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6537-linux.tar.gz
wget --no-check-certificate -O ./1v1/plugin.tar.gz https://github.com/splewis/csgo-multi-1v1/releases/download/1.1.10/multi1v1_1.1.10.zip
```

将CSGO服务器的CFG文件夹链接到插件文件夹
```bash
ln -s `pwd`/csgo-server/csgo/cfg/ `pwd`/1v1/cfg
```

解压插件
```bash
tar zxkf ./1v1/mmsource.tar.gz -C ./1v1/
tar zxkf ./1v1/sourcemod.tar.gz -C ./1v1/
tar zxkf ./1v1/plugin.tar.gz -C ./1v1/
```

清理下载的压缩文件
```bash
rm ./1v1/*.tar.gz
```

创建和启动容器的方式同样是有命令行和`docker-compose`，其中的参数和挂载文件夹路径**根据自己需要做出改变**，特别介绍下以下几个参数:
- `MAPGROUP`: 创意工坊地图合集，管理游戏结束后投票下一张地图的菜单，想用官方地图组可以直接改为`mg_active`或其他
- `MAP`: 创意工坊地图ID，想用官方图可以直接改为`de_dust2`或其他
- `AUTHKEY`: Steam网页API密钥，使用创意工坊地图时要用，如果只需要启动官方地图，则设置为`NONE`即可

命令行创建和启动容器
```bash
sudo docker run -d --name=csgo-1v1 -net=host \
     -v `pwd`/steamcmd:/steamcmd \
     -v `pwd`/csgo-server:/csgo-server \
     -v `pwd`/1v1:/mod
     -e TICKRATE=128 \
     -e GAMETYPE=0 \
     -e GAMEMODE=0 \
     -e MAPGROUP=279177557 \
     -e MAP=279708083 \
     -e AUTHKEY=xxxxxxxxxx \
     registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:mods
```

`docker-compose`创建，需要先创建一个YAML配置文件
```yaml
# 文件名: docker-csgo-1v1.yaml
# docker-csgo:mods 的示例配置文件
version: '3'
services:
  csgo-1v1:
    container_name: csgo-1v1
    restart: always
    image: registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:mods
    network_mode: host
    volumes:
      - /home/fisher/steamcmd:/steamcmd # 冒号前的挂载路径需要根据自己的配置改变，可以使用pwd命令查看当前路径
      - /home/fisher/csgo-server:/csgo-server   # 同上
      - /home/fisher/1v1:/mod   # 同上
    environment:
      - TICKRATE=128
      - GAMETYPE=0
      - GAMEMODE=0
      - MAPGROUP=279177557
      - MAP=279708083
      - AUTHKEY=xxxxxxxxxx
```
使用`docker-compose`创建和启动容器
```bash
sudo docker-compose -f docker-csgo-1v1.yaml up -d
```

## FAQ
1. 如何判断`docker-csgo:installer`正确完成了安装？  
查看`steamcmd`和`csgo-server`文件夹中是否有文件，如果有文件且安装器容器已经停止，可以认为正确完成了安装。查看安装过程中容器的日志可以使用命令`sudo docker logs csgo-installer --tail=50`

2. 如何更改服务器的名称、密码、RCON密码等其他配置？  
可以编辑`server.cfg`文件，容器只配置了部分启动参数，更多的参数可以通过这个文件配置，文件路径: `csgo-server/csgo/cfg/server.cfg`

3. 使用创意工坊地图后，服务器启动速度很慢？  
使用创意工坊地图和创意工坊地图合集后，服务器启动时需要下载这些地图，这需要看服务器所在的地区，某些地区需要使用特殊方式才能下载成功

4. 服务器空闲一段时间后，重新连接很慢？  
服务器中没有玩家后，一段时间后会挂起，此时客户端重新连接，服务器需要重新启动一次，耐心等待即可

5. 连接服务器后马上回弹到主界面，控制台显示`server is running on an older version`？  
服务器运行的还是旧版CSGO，重新启动容器就能自动更新了。命令行重启: `sudo docker restart csgo-origin`，`docker-compose`重启: `sudo docker-compose -f docker-csgo-origin.yaml restart -d`

6. 可以同时启动多个容器吗？  
理论上，使用不同的端口是可以同时启动多个容器的，但可能存在一个Steam Account(固定在`server.cfg`中，并没有使用参数化启动的配置)只能启动一个服务器的限制。由于本仓库的初衷是一份服务器游戏文件+多份Mod的快捷切换和管理，因此本人没有尝试过同时启动多个容器，有兴趣的朋友可以试一下

## 2024.5.26更新
by:XBDJ
- 更新ymal以同时启动多个容器
```
version: '3'
#1服
services:
  csgo-origin:
    container_name: csgo-origin
    restart: always
    image: registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:origin
    network_mode: host
    volumes:
      - /home/ubuntu/steamcmd:/steamcmd # 冒号前的挂载路径需要根据自己的配置改变，可以使用pwd命令查看当前路径
      - /home/ubuntu/csgo-server:/csgo-server   # 同上
      - /home/ubuntu/li/server.cfg:/csgo-server/csgo/cfg #该文件为插件服文件无mod服可忽略
      - /home/ubuntu/li/csgoserver.cfg:/csgo-server/csgo/cfg #同上
    environment:
      - TICKRATE=128
      - GAMETYPE=0
      - GAMEMODE=0
      - MAPGROUP=mg_active
      - MAP=kz_7in1
      - MAXPLAYERS=12

#2服
version: '3'
services:
  csgo-origin:
    container_name: csgo-origin-2
    restart: always
    image: registry.cn-shenzhen.aliyuncs.com/fisheryung/docker-csgo:origin
    network_mode: host
    volumes:
      - /home/ubuntu/steamcmd:/steamcmd
      - /home/ubuntu/csgo-server:/csgo-server
      - /home/ubuntu/li/server-2.cfg:/csgo-server/csgo/cfg/
      - /home/ubuntu/li/csgoserver-2.cfg:/csgo-server/csgo/cfg/
    environment:
      - TICKRATE=128
      - GAMETYPE=0
      - GAMEMODE=0
      - MAPGROUP=mg_active
      - MAP=kz_7in1
      - MAXPLAYERS=12
      - port=27016
```
