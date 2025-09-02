#!/bin/bash

# Подключаем общие функции
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../common.sh"

info "Установка nginx..."

# Установка nginx
sudo apt-get -qq install -y nginx
success "nginx установлен"

# Включение сервиса
sudo systemctl enable nginx
success "nginx сервис включён"

# Создание директории для сервисов
sudo mkdir -p /etc/nginx/services
success "Создана директория /etc/nginx/services"

# Установка прав доступа
sudo chown -R $USER:$USER /etc/nginx/services
sudo chmod -R 755 /etc/nginx/services
success "Установлены права доступа для /etc/nginx/services"

# Копирование конфигурации (ищем файл рядом со скриптом)
NGINX_CONF="${SCRIPT_DIR}/nginx.conf"
if [[ -f "$NGINX_CONF" ]]; then
    sudo cp "$NGINX_CONF" /etc/nginx/nginx.conf
    success "Конфигурация nginx скопирована"
else
    error "Файл nginx.conf не найден: $NGINX_CONF"
    exit 1
fi
