#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../common.sh"

# Запрос имени хоста у пользователя
read -p "Введите имя хоста (по умолчанию ktulhu): " USER_HOSTNAME
HOSTNAME_VAR="${USER_HOSTNAME:-ktulhu}"

info "Установка hostname: $HOSTNAME_VAR"

if grep -q "export HOSTNAME_VAR=" ~/.profile; then
    sed -i "s/export HOSTNAME_VAR=.*/export HOSTNAME_VAR=\"$HOSTNAME_VAR\"/" ~/.profile
    success "Обновлена переменная HOSTNAME_VAR в ~/.profile"
else
    echo "export HOSTNAME_VAR=\"$HOSTNAME_VAR\"" >> ~/.profile
    success "Добавлена переменная HOSTNAME_VAR в ~/.profile"
fi

source ~/.profile

sudo hostnamectl set-hostname "$HOSTNAME_VAR"
success "Системный hostname установлен: $HOSTNAME_VAR"

info "Установка avahi-daemon..."
sudo apt install -y avahi-daemon
success "avahi-daemon установлен"

sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
success "avahi-daemon сервис включён и запущен"
