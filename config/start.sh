#!/bin/bash
set -e

CONFIG_DIR="/app/config/"

cd ${CONFIG_DIR}

# 拉取七彩石配置，替换nginx.conf.tmpl模板中预设的变量，生成nginx.conf配置文件
./generate_config.sh ${RAINBOW_APPID} ${RAINBOW_GROUP} ${CONFIG_DIR} nginx.conf

# 删除默认配置文件
rm -f /etc/nginx/nginx.conf

# 将生成的nginx.conf配置文件移动到指定目录下
mv ${CONFIG_DIR}nginx.conf /etc/nginx/

# 回到/app根目录
cd ../

# 启动nginx
nginx -g "daemon off;"
