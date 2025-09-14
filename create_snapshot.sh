#!/bin/bash

if ! command -v timeshift &> /dev/null; then
  echo "Timeshift не установлен. Выполняется установка"
  sudo apt-get install timeshift
  exit 1
fi

read -p "Введите имя снимка (или нажмите Enter для значения по умолчанию 'Origin snapshot'): " snapshot_name

if [ -z "$snapshot_name" ]; then
  snapshot_name="Origin snapshot"
fi

echo "Создание снимка с именем: $snapshot_name"

sudo timeshift --create \
  --comments "$snapshot_name" \
  --snapshot-device /dev/mapper/ubuntu--vg-ubuntu--lv \
  --rsync

if [ $? -eq 0 ]; then
  echo "Снимок '$snapshot_name' успешно создан."
else
  echo "Ошибка при создании снимка '$snapshot_name'."
  exit 1
fi
