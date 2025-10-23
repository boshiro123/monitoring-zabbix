#!/bin/bash

# Скрипт остановки мониторинга

set -e

echo "=========================================="
echo "  Остановка системы мониторинга"
echo "=========================================="
echo ""

if command -v docker-compose &> /dev/null; then
    docker-compose stop
else
    docker compose stop
fi

echo ""
echo "✅ Все контейнеры остановлены"
echo ""

