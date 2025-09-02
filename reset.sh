#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}⚠️  СИСТЕМА БУДЕТ ОТКАЧЕНА К ЧИСТОМУ СОСТОЯНИЮ!${NC}"
echo -e "${RED}Все изменения будут потеряны!${NC}"
echo ""
echo -e "${RED}Вы уверены? (y/N)${NC}"
read answer

if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
    echo "Отменено"
    exit 0
fi

echo "Остановка сервисов..."
sudo systemctl stop networking 2>/dev/null
sudo systemctl stop ssh 2>/dev/null
sudo systemctl stop docker 2>/dev/null
sudo systemctl stop nginx 2>/dev/null

echo "Выполняется откат к чистому состоянию..."
sudo lvconvert --merge /dev/ubuntu-vg/origin

echo "Перезагрузка..."
sudo reboot
