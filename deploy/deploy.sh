#!/usr/bin/env bash
# TT3Dato — поднять всё на VPS одной командой и проверить связность.
#
#   ./deploy.sh            # поднять + проверить
#   ./deploy.sh --down     # остановить
#   ./deploy.sh --status   # только статус и проверка связности
#
# Требования: docker + docker compose (plugin) на хосте.

set -euo pipefail
cd "$(dirname "$0")"

COMPOSE="docker compose"

# ─── Проверка Docker ───
command -v docker >/dev/null 2>&1 || { echo "✖ Docker не установлен"; exit 1; }
docker info >/dev/null 2>&1 || { echo "✖ Docker daemon не запущен"; exit 1; }

# ─── Конфиг ───
if [ ! -f .env ]; then
  echo "✖ Нет .env — создайте: cp .env.example .env"
  exit 1
fi

# Подгрузить значения по умолчанию
DASHBOARD_PORT="${DASHBOARD_PORT:-20128}"
API_PORT="${API_PORT:-20129}"
UI_PORT="${UI_PORT:-3000}"

action="${1:-up}"

case "${action}" in
  up)
    echo "→ Поднимаю сервисы..."
    ${COMPOSE} up -d
    echo "→ Ожидаю готовности роутера (до 60с)..."
    for i in $(seq 1 30); do
      if curl -sf -m 3 "http://localhost:${DASHBOARD_PORT}/v1/models" >/dev/null 2>&1; then
        echo "✓ Роутер готов (порт ${DASHBOARD_PORT})"
        break
      fi
      [ "${i}" -eq 30 ] && { echo "✖ Роутер не поднялся за 60с — смотрите: ${COMPOSE} logs router"; exit 1; }
      sleep 2
    done
    echo "→ Статус контейнеров:"
    ${COMPOSE} ps
    ;;

  down)
    echo "→ Останавливаю сервисы..."
    ${COMPOSE} down
    exit 0
    ;;

  status|check|health)
    ;;

  *)
    echo "Неизвестная команда: ${action}"
    echo "Использование: $0 [up|down|status]"
    exit 1
    ;;
esac

# ─── Проверка связности ───
echo ""
echo "═ Проверка связности ═"

# 1. Роутер отвечает
MODELS=$(curl -sf -m 5 "http://localhost:${DASHBOARD_PORT}/v1/models" 2>/dev/null || true)
if [ -n "${MODELS}" ]; then
  COUNT=$(echo "${MODELS}" | python3 -c "import json,sys; print(len(json.load(sys.stdin).get('data',[])))" 2>/dev/null || echo "?")
  echo "✓ Роутер /v1/models: ${COUNT} моделей"
else
  echo "✖ Роутер /v1/models: нет ответа"
fi

# 2. Бесплатная модель отвечает (non-streaming, для код-агента)
RESP=$(curl -sf -m 60 "http://localhost:${DASHBOARD_PORT}/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"oc/deepseek-v4-flash-free\",\"messages\":[{\"role\":\"user\",\"content\":\"ping\"}],\"max_tokens\":200,\"stream\":false}" 2>/dev/null || true)
if [ -n "${RESP}" ]; then
  MODEL=$(echo "${RESP}" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('model','?'))" 2>/dev/null || echo "?")
  echo "✓ Бесплатная модель (non-streaming): ${MODEL}"
else
  echo "✖ Бесплатная модель не ответила — возможно, исчерпан дневной лимит провайдера"
fi

# 3. Код-агент в сети compose
AGENT_UP=$(${COMPOSE} exec -T agent python3 -c "import openhands; print('ok')" 2>/dev/null || true)
if [ "${AGENT_UP}" = "ok" ]; then
  echo "✓ Код-агент OpenHands: установлен, контейнер жив"
else
  echo "⚠ Код-агент: контейнер не проверен (может ещё инициализироваться)"
fi

# 4. Веб-интерфейс
UI_OK=$(curl -sf -m 5 -o /dev/null -w "%{http_code}" "http://localhost:${UI_PORT}/" 2>/dev/null || true)
if [ "${UI_OK}" = "200" ]; then
  echo "✓ Веб-интерфейс: http://localhost:${UI_PORT}/"
else
  echo "⚠ Веб-интерфейс: порт ${UI_PORT} (код ${UI_OK:-нет ответа})"
fi

echo ""
echo "Готово. Роутер-дашборд: http://localhost:${DASHBOARD_PORT}"
