#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

info "Начинаем установку проекта..."
sudo apt-get update -qq

MODULES_DIR="${SCRIPT_DIR}/services"

if [[ ! -d "$MODULES_DIR" ]]; then
    error "Папка с модулями не найдена: $MODULES_DIR"
    exit 1
fi

for module in docker nginx gitlab penpot bookstack wekan; do
    MODULE_PATH="$MODULES_DIR/$module/install.sh"
    
    if [[ -f "$MODULE_PATH" ]]; then
        info "Запуск модуля: $module"
        bash "$MODULE_PATH"
        if [[ $? -eq 0 ]]; then
            success "Модуль $module выполнен успешно"
        else
            error "Ошибка в модуле $module"
            exit 1
        fi
    else
        warn "Модуль не найден: $MODULE_PATH"
    fi
done

success "Установка всех модулей завершена"
