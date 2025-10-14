#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../common.sh"

info "Получение IP-адреса Wi-Fi интерфейса..."

WIFI_IP=$(get_wifi_ip)

if [ -z "$WIFI_IP" ]; then
    error "Не удалось определить IP-адрес Wi-Fi интерфейса"
    exit 1
fi

success "Найден IP-адрес Wi-Fi: $WIFI_IP"

info "Установка и настройка GitLab..."

sudo rm -r ./gitlab-data/

DOCKER_COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
if [[ ! -f "$DOCKER_COMPOSE_FILE" ]]; then
    error "Файл docker-compose.yml не найден: $DOCKER_COMPOSE_FILE"
    exit 1
fi

info "Запуск GitLab через Docker Compose..."
debug "Используется файл: $DOCKER_COMPOSE_FILE"

sudo docker-compose -f "$DOCKER_COMPOSE_FILE" up -d

if [ $? -eq 0 ]; then
    success "GitLab успешно запущен в Docker"
else
    error "Ошибка при запуске GitLab через Docker Compose"
    exit 1
fi

info "Ожидание готовности Gitlab..."

while ! curl -f -s -o /dev/null --connect-timeout 5 --max-time 10 http://localhost:5001/users/sign_in; do
	sleep 10;
done

success "Конфигурация GitLab успешно применена"

INITIAL_PASSWORD=$(docker exec gitlab awk '/^Password:/ {print $2}' /etc/gitlab/initial_root_password 2>/dev/null)
if [ -n "$INITIAL_PASSWORD" ]; then
    success "Первоначальный вход [login: root password: $INITIAL_PASSWORD]"
else
    info "Не удалось прочитать initial_root_password — возможно, он уже удалён."
fi
