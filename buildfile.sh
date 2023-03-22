echo "param:$1"

ENV=$1

npm config set user root

npm config set registry https://mirrors.tencent.com/npm/

npm install --unsafe-perm

if [[ $ENV == "production" ]]; then
  npm run build:prod
else
  npm run build
fi  