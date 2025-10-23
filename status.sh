#!/bin/bash

# Скрипт проверки статуса мониторинга

echo "=========================================="
echo "  Статус системы мониторинга"
echo "=========================================="
echo ""

# Проверка запущенных контейнеров
echo "📊 Статус контейнеров:"
echo "----------------------------------------"
docker ps --filter "name=zabbix" --filter "name=grafana" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "❌ Контейнеры не запущены или Docker недоступен"
    exit 1
fi

echo ""
echo "----------------------------------------"

# Проверка здоровья Zabbix Server
echo ""
echo "🏥 Проверка здоровья Zabbix Server:"
ZBXSRV_HEALTH=$(docker inspect --format='{{.State.Health.Status}}' zabbix-server 2>/dev/null)
if [ "$ZBXSRV_HEALTH" = "healthy" ]; then
    echo "✅ Zabbix Server: здоров"
else
    echo "⚠️  Zabbix Server: $ZBXSRV_HEALTH"
fi

# Проверка подключения агента
echo ""
echo "🔌 Проверка Zabbix Agent:"
docker exec zabbix-agent2 zabbix_agent2 -t agent.ping 2>/dev/null | grep -q "1"
if [ $? -eq 0 ]; then
    echo "✅ Zabbix Agent: работает"
else
    echo "❌ Zabbix Agent: не отвечает"
fi

# Проверка доступности сервисов
echo ""
echo "🌐 Проверка доступности сервисов:"

# Zabbix Frontend
if curl -s -o /dev/null -w "%{http_code}" http://localhost 2>/dev/null | grep -q "200\|302"; then
    echo "✅ Zabbix Web UI: доступен на http://localhost"
else
    echo "❌ Zabbix Web UI: недоступен"
fi

# Grafana
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null | grep -q "200\|302"; then
    echo "✅ Grafana: доступен на http://localhost:3000"
else
    echo "❌ Grafana: недоступен"
fi

# Использование ресурсов
echo ""
echo "💾 Использование ресурсов:"
echo "----------------------------------------"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" $(docker ps --filter "name=zabbix" --filter "name=grafana" -q) 2>/dev/null

# Использование диска
echo ""
echo "📁 Использование диска:"
echo "----------------------------------------"
du -sh db/ 2>/dev/null | awk '{print "База данных:  " $1}'
du -sh grafana/ 2>/dev/null | awk '{print "Grafana:      " $1}'

echo ""
echo "=========================================="
echo ""
echo "💡 Для просмотра логов используйте:"
echo "   docker logs zabbix-server"
echo "   docker logs zabbix-agent2"
echo "   docker logs grafana"
echo ""

