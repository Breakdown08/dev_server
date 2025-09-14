#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../common.sh"
source ~/.profile

info "Проверка переменной окружения..."
echo "${HOSTNAME_VAR:-NULL}"
if [ -z "$HOSTNAME_VAR" ]; then
    error "Переменная окружения HOSTNAME_VAR не установлена"
    exit 1
fi

info "Установка и настройка локальных поддоменов.."

DOCKER_COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
if [[ ! -f "$DOCKER_COMPOSE_FILE" ]]; then
    error "Файл docker-compose.yml не найден: $DOCKER_COMPOSE_FILE"
    exit 1
fi
info "Запуск Go-avahi-cname через Docker Compose..."
debug "Используется файл: $DOCKER_COMPOSE_FILE"

sudo HOSTNAME=$HOSTNAME_VAR docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
if [ $? -eq 0 ]; then
    success "Домены готовы к использованию"
else
    error "Ошибка во время настройки доменов" 
    exit 1
fi
