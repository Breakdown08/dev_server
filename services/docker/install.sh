#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../common.sh"

info "Установка Docker и Docker Compose..."

info "Скачивание установочного скрипта Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
if [ $? -eq 0 ]; then
    success "Скрипт установки Docker скачан"
else
    error "Ошибка при скачивании скрипта установки Docker"
    exit 1
fi

info "Установка Docker..."
sudo sh get-docker.sh
if [ $? -eq 0 ]; then
    success "Docker установлен"
else
    error "Ошибка при установке Docker"
    rm -f get-docker.sh
    exit 1
fi

rm -f get-docker.sh
success "Временный файл удалён"

info "Добавление пользователя в группу docker..."
sudo usermod -aG docker $USER
success "Пользователь добавлен в группу docker"

info "Установка Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
if [ $? -eq 0 ]; then
    success "Docker Compose скачан"
else
    error "Ошибка при скачивании Docker Compose"
    exit 1
fi

sudo chmod +x /usr/local/bin/docker-compose
success "Права на выполнение установлены для Docker Compose"

info "Включение и запуск сервиса Docker..."
sudo systemctl enable docker
sudo systemctl start docker

if [ $? -eq 0 ]; then
    success "Сервис Docker включён и запущен"
else
    error "Ошибка при запуске сервиса Docker"
    exit 1
fi
