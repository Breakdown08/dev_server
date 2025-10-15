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

# --- Настройка HTML ---
SOURCE_HTML="${SCRIPT_DIR}/index.html"
WWW_DIR="/var/www/dashboard"

if [[ ! -f "$SOURCE_HTML" ]]; then
    error "Файл index.html не найден: $SOURCE_HTML"
    exit 1
fi

info "Копирование и настройка index.html в $WWW_DIR..."
sudo mkdir -p "$WWW_DIR"
sudo cp "$SOURCE_HTML" "$WWW_DIR/index.html"
sudo sed -i "s#yourserver#$WIFI_IP#g" "$WWW_DIR/index.html"
success "index.html обработан: все ссылки ведут на $WIFI_IP"

# --- Настройка Nginx ---
NGINX_CONF_SOURCE="${SCRIPT_DIR}/nginx.conf"
NGINX_CONF_TEMP="/tmp/dashboard.nginx.conf"
NGINX_CONF_TARGET="/etc/nginx/services/dashboard.conf"

if [[ ! -f "$NGINX_CONF_SOURCE" ]]; then
    error "Файл nginx.conf не найден: $NGINX_CONF_SOURCE"
    exit 1
fi

info "Обработка и копирование конфигурации Nginx..."
sed "s#yourserver#$WIFI_IP#g" "$NGINX_CONF_SOURCE" > "$NGINX_CONF_TEMP"
sudo cp "$NGINX_CONF_TEMP" "$NGINX_CONF_TARGET"

rm -f "$NGINX_CONF_TEMP"

# --- Перезагрузка Nginx ---
info "Проверка и перезагрузка Nginx..."
if sudo nginx -t; then
    sudo systemctl reload nginx
    success "Dashboard успешно настроен и доступен по адресу: http://${WIFI_IP}/"
else
    error "Ошибка при проверке или перезагрузке Nginx"
    exit 1
fi

