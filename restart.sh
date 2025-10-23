#!/bin/bash

# Скрипт перезапуска мониторинга

set -e

echo "=========================================="
echo "  Перезапуск системы мониторинга"
echo "=========================================="
echo ""

if [ "$1" = "clean" ]; then
    echo "⚠️  Режим CLEAN: все данные будут удалены!"
    read -p "Продолжить? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Отменено"
        exit 0
    fi
    
    echo ""
    echo "🗑️  Остановка и удаление контейнеров..."
    if command -v docker-compose &> /dev/null; then
        docker-compose down -v
    else
        docker compose down -v
    fi
    
    echo "🗑️  Удаление данных..."
    rm -rf db/* grafana/* zbx_env/*
    
    echo "✅ Данные удалены"
    echo ""
fi

echo "🛑 Остановка контейнеров..."
if command -v docker-compose &> /dev/null; then
    docker-compose down
else
    docker compose down
fi

echo ""
echo "🚀 Запуск контейнеров..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    docker compose up -d
fi

echo ""
echo "⏳ Ожидание запуска (30 секунд)..."
sleep 30

echo ""
echo "✅ Система перезапущена!"
echo ""
echo "Проверьте статус: ./status.sh"
echo ""

