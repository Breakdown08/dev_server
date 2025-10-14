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

info "Установка и настройка BookStack..."

DOCKER_COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
if [[ ! -f "$DOCKER_COMPOSE_FILE" ]]; then
    error "Файл docker-compose.yml не найден: $DOCKER_COMPOSE_FILE"
    exit 1
fi

info "Запуск BookStack через Docker Compose с IP-адресом..."
debug "Используется файл: $DOCKER_COMPOSE_FILE"
debug "BOOKSTACK_EXPORTER_HOST_IP будет установлено в: $WIFI_IP"

BOOKSTACK_EXPORTER_HOST_IP="$WIFI_IP" sudo -E docker compose -f "$DOCKER_COMPOSE_FILE" up -d

if [ $? -eq 0 ]; then
    success "BookStack успешно запущен в Docker"
else
    error "Ошибка при запуске BookStack через Docker Compose"
    exit 1
fi

info "Ожидание готовности BookStack..."

while ! curl -f -s -o /dev/null --connect-timeout 5 --max-time 10 "http://${WIFI_IP}:5005"; do
    sleep 10
done

success "BookStack успешно запущен и доступен по адресу: http://${WIFI_IP}:5005"
