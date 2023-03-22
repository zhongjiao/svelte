#!/bin/bash
set -e
#
# 说明：
#   本脚本用于根据目标文件夹下的配置文件模板，拉取Rainbow上的配置，生成真实的配置文件。
#
#   ./generate_config.sh appid group target_dir config_file_name [other_config_file_name]
#
#   执行本脚本需要传入不少于 4 个参数
#     - appid、group，传入 rainbow 配置的 appid 和 group
#     - appid，传入 rainbow 配置的 appid
#     - target_dir，要生成的配置文件及其目标位置
#     - config_file_name，要生成的配置文件名称，包含扩展名。可以有多个文件名参数。（其模板名称为“配置文件名.tmpl”）
#   ./generate_config.sh <appid> <group> <../src/Tencent.OA.ATQ.Host.Dispatcher> <appsettings.json>
#
# 示例：
#
#   假如目录结构为：
#   .
#   ├──/rainbow
#   │  └── generate_config.sh
#   └─ /src
#      └── project_a
#         ├── config_file_1.json.toml
#         └── config_file_2.xml.toml
#
#    以上，在 ./rainbow 目录执行如下命令，则会在 project_a 目录下生成 config_file_1.json 、 config_file_2.xml 两个配置文件
#
#   cd ./rainbow
#   ./generate_config.sh appid group ../src/project_a config_file_1.json config_file_2.xml
#
APPID=$1; shift
GROUP=$1; shift
TARGET_DIR=$1; shift
FILES=($@)
WORKSPACE_DIR="./tmp-workspace"
generate_config(){
  echo "[log]
level = \"debug\"
# dir = \"./log\" # 指定本地log目录，默认不写本地log
[backend]
scheme = \"http\"
# 注意！这个地址是devcloud下的测试环境，不是rainbow的正式环境
addr = \"http://api.rainbow.oa.com:8080\"
[template]
conf_dir = \"./${WORKSPACE_DIR}\"
" > ${WORKSPACE_DIR}/config.toml
}
generate_confd_toml(){
  filename=$1
  echo "# 模板文件
src = \"${filename}.tmpl\"

# 要生成的配置文件
dest = \"${TARGET_DIR}/${filename}\"

# 执行命令前检查，失败的话则不执行reload_cmd
check_cmd = \"echo 'check'\"

# 程序重新加载配置的命令
reload_cmd = \"echo 'reload'\"

# 配置中心应用ID
app_id = \"&appId&\"

# 配置中心的group，一个配置文件中使用的key都再同一个group下
group = \"&group&\"" > ${WORKSPACE_DIR}/conf.d/${filename}.toml
}
apply_appid(){
  filename=$1
  sed -i -e "s/&appId&/$(echo ${APPID})/g" ${WORKSPACE_DIR}/conf.d/${filename}.toml
  sed -i -e "s/&group&/$(echo ${GROUP})/g" ${WORKSPACE_DIR}/conf.d/${filename}.toml
}
mkdir -p ${WORKSPACE_DIR}/templates
mkdir -p ${WORKSPACE_DIR}/conf.d
generate_config
for filename in "${FILES[@]}"
do
  echo "processing ${filename}..."
  generate_confd_toml ${filename}
  cp ${TARGET_DIR}/${filename}.tmpl ${WORKSPACE_DIR}/templates/${filename}.tmpl
  apply_appid ${filename}
done
rainbow_confd -onetime -conf_file=${WORKSPACE_DIR}/config.toml
rm -rf ./${WORKSPACE_DIR}

