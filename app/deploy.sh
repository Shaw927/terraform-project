#!/bin/bash
set -e

# Установка Docker
apt-get update -y
apt-get install -y ca-certificates curl gnupg

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Клонируем репозиторий
mkdir -p /opt
cd /opt

if [ -d "shvirtd-example-python" ]; then
  cd shvirtd-example-python
  git pull
else
  git clone https://github.com/Shaw927/shvirtd-example-python.git
  cd shvirtd-example-python
fi

# Создаём .env если нет
if [ ! -f .env ]; then
  cat > .env <<EOF
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=app
MYSQL_USER=app_user
MYSQL_PASSWORD=password
EOF
fi 

docker compose up -d

docker ps -a
