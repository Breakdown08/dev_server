#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../common.sh"
source ~/.bashrc

info "Проверка переменной окружения..."
echo "${HOSTNAME_VAR:-NULL}"
if [ -z "$HOSTNAME_VAR" ]; then
    error "Переменная окружения HOSTNAME_VAR не установлена"
    exit 1
fi

info "Установка и настройка GitLab..."

DOCKER_COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
if [[ ! -f "$DOCKER_COMPOSE_FILE" ]]; then
    error "Файл docker-compose.yml не найден: $DOCKER_COMPOSE_FILE"
    exit 1
fi
info "Запуск GitLab через Docker Compose..."
debug "Используется файл: $DOCKER_COMPOSE_FILE"

docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
if [ $? -eq 0 ]; then
    success "GitLab успешно запущен в Docker"
else
    error "Ошибка при запуске GitLab через Docker Compose"
    exit 1
fi

info "Настройка nginx конфигурации для GitLab..."

NGINX_CONF="${SCRIPT_DIR}/nginx.conf"
if [[ ! -f "$NGINX_CONF" ]]; then
    error "Файл конфигурации nginx не найден: $NGINX_CONF"
    exit 1
fi

config_content=$(cat "$NGINX_CONF")
success "Конфигурационный файл nginx загружен"

updated_config="${config_content//placeholder/$HOSTNAME_VAR.local}"
success "Выполнена замена placeholder на $HOSTNAME_VAR.local"

echo "$updated_config" | sudo tee /etc/nginx/services/gitlab.conf > /dev/null
if [ $? -eq 0 ]; then
    success "Конфиг nginx успешно записан в /etc/nginx/services/gitlab.conf"
else
    error "Ошибка при записи файла конфигурации nginx"
    exit 1
fi
