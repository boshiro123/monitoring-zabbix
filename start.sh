#!/bin/bash

# Скрипт запуска мониторинга Zabbix + Grafana

set -e

echo "=========================================="
echo "  Запуск системы мониторинга"
echo "=========================================="
echo ""

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен!"
    exit 1
fi

# Проверка наличия Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose не установлен!"
    exit 1
fi

# Создание необходимых директорий
echo "📁 Создание директорий..."
mkdir -p db
mkdir -p grafana
mkdir -p zbx_env/alertscripts
mkdir -p zbx_env/externalscripts

# Установка прав доступа для Grafana
echo "🔐 Настройка прав доступа..."
chmod -R 777 grafana 2>/dev/null || sudo chmod -R 777 grafana

# Запуск контейнеров
echo ""
echo "🚀 Запуск контейнеров..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    docker compose up -d
fi

echo ""
echo "⏳ Ожидание запуска сервисов (30 секунд)..."
sleep 30

# Проверка статуса контейнеров
echo ""
echo "📊 Статус контейнеров:"
docker ps --filter "name=zabbix" --filter "name=grafana" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=========================================="
echo "  ✅ Система мониторинга запущена!"
echo "=========================================="
echo ""
echo "📍 Адреса сервисов:"
echo ""
echo "  Zabbix Web UI:"
echo "    http://localhost"
echo "    Логин: Admin"
echo "    Пароль: zabbix"
echo ""
echo "  Grafana:"
echo "    http://localhost:3000"
echo "    Логин: aDm1N"
echo "    Пароль: r4FD6GEH7zsXfXZs"
echo ""
echo "=========================================="
echo ""
echo "📝 Следующие шаги:"
echo "  1. Зайдите в Zabbix Web UI"
echo "  2. Перейдите в Configuration → Hosts"
echo "  3. Найдите хост 'ubuntu25' (или создайте новый)"
echo "  4. Убедитесь что применен шаблон 'Linux by Zabbix agent'"
echo "  5. Проверьте что статус агента 'Available' (зеленый)"
echo ""
echo "  Для Grafana:"
echo "  1. Добавьте Data Source: Zabbix"
echo "  2. URL: http://zabbix-server:10051"
echo "  3. Импортируйте готовые dashboard для Zabbix"
echo ""
echo "=========================================="

