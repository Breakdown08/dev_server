#!/bin/bash

# Цвета
COLOR_RESET='\033[0m'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_CYAN='\033[0;36m'

# Универсальная функция стилизованного вывода
styled_echo() {
    local color="$1"
    local prefix="$2"
    local message="$3"
    echo -e "${color}[${prefix}]$(printf '%-8s' "")${message}${COLOR_RESET}"
}

# Стандартные функции для вывода
info()    { styled_echo "$COLOR_BLUE"    "INFO"    "$1"; }
success() { styled_echo "$COLOR_GREEN"   "SUCCESS" "$1"; }
warn()    { styled_echo "$COLOR_YELLOW"  "WARN"    "$1"; }
error()   { styled_echo "$COLOR_RED"     "ERROR"   "$1"; }
debug()   { styled_echo "$COLOR_PURPLE"  "DEBUG"   "$1"; }

get_wifi_ip() {
    local wifi_ip=""
    for iface in /sys/class/net/*/wireless; do
        if [[ -e "$iface" ]]; then
            local iface_name
            iface_name=$(basename "$(dirname "$iface")")
            wifi_ip=$(ip -4 addr show "$iface_name" 2>/dev/null | grep -oP 'inet \K[\d.]+')
            if [[ -n "$wifi_ip" ]]; then
                echo "$wifi_ip"
                return 0
            fi
        fi
    done
    return 1
}
