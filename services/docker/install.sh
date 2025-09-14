#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../common.sh"

info "Начало установки Docker..."

info "Установка зависимостей..."
sudo apt-get install -qq curl software-properties-common ca-certificates apt-transport-https -y
success "Зависимости установлены"

info "Добавление GPG-ключа Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null
success "GPG-ключ Docker добавлен"

info "Добавление репозитория Docker..."
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable"| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
success "Репозиторий Docker добавлен"

info "Повторное обновление списка пакетов..."
sudo apt-get update -qq
success "Список пакетов обновлён"

info "Установка Docker Engine..."
sudo apt-get install -qq docker-ce -y
info "Проверка статуса активности Docker..."
sudo systemctl is-active docker
success "Docker Engine установлен"

info "Добавление текущего пользователя в группу docker..."
sudo usermod -aG docker $USER
success "Пользователь добавлен в группу docker.

info "Установка Docker Compose..."
sudo apt-get install docker-compose
sudo docker-compose version

success "Установка Docker завершена!"
