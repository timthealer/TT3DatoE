#!/bin/bash
# Запуск код-агента Coddy (в контейнере scripts/deploy/agent или локально).
# Пример использования:
#   ROUTER_BASE_URL=http://router:20128/v1 ./start-coddy.sh
set -euo pipefail

ROUTER_BASE_URL="${ROUTER_BASE_URL:-http://localhost:20128/v1}"
PORT="${CODDY_PORT:-12345}"
CONFIG="${CODDY_CONFIG:-/etc/coddy/config.yaml}"

if [ ! -f "$CONFIG" ]; then
  echo "Конфиг не найден: $CONFIG"
  echo "Создайте его из шаблона: scripts/deploy/agent/coddy-config.example.yaml"
  exit 1
fi

export ROUTER_BASE_URL
export ROUTER_API_KEY="${ROUTER_API_KEY:-}"

exec coddy http -P "$PORT" -config "$CONFIG"
