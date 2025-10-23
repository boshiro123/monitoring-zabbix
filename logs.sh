#!/bin/bash

# Скрипт для просмотра логов

show_help() {
    echo "Использование: ./logs.sh [СЕРВИС]"
    echo ""
    echo "Доступные сервисы:"
    echo "  server    - Zabbix Server"
    echo "  agent     - Zabbix Agent"
    echo "  frontend  - Zabbix Frontend"
    echo "  grafana   - Grafana"
    echo "  mysql     - База данных MySQL"
    echo "  all       - Все сервисы (по умолчанию)"
    echo ""
    echo "Примеры:"
    echo "  ./logs.sh          # показать все логи"
    echo "  ./logs.sh server   # только логи Zabbix Server"
    echo "  ./logs.sh agent    # только логи Zabbix Agent"
}

SERVICE=${1:-all}

case $SERVICE in
    server)
        docker logs -f zabbix-server
        ;;
    agent)
        docker logs -f zabbix-agent2
        ;;
    frontend)
        docker logs -f zabbix-frontend
        ;;
    grafana)
        docker logs -f grafana
        ;;
    mysql)
        docker logs -f zabbix-mariadb
        ;;
    all)
        docker-compose logs -f
        ;;
    -h|--help)
        show_help
        ;;
    *)
        echo "❌ Неизвестный сервис: $SERVICE"
        echo ""
        show_help
        exit 1
        ;;
esac

