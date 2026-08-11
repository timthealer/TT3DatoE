#!/usr/bin/env bash
# Запуск код-агента OpenHands (headless) через наш бесплатный роутер.
#
# Требования:
#   1. Роутер запущен (OmniRoute): см. llm-router/config/free-router.json
#   2. Docker установлен и запущен на этой машине (см. llm-router/config/docker-agent.md)
#   3. openhands-ai установлен:  pip install openhands-ai
#
# Использование:
#   ./start-code-agent.sh "опиши задачу для агента"
#   ./start-code-agent.sh -f /path/to/task.txt

set -euo pipefail

# ─── Конфигурация (можно переопределить env-переменными) ───
ROUTER_BASE_URL="${ROUTER_BASE_URL:-http://localhost:20128}"
ROUTER_MODEL="${ROUTER_MODEL:-oc/deepseek-v4-flash-free}"
DOCKER_HOST="${DOCKER_HOST:-unix:///var/run/docker.sock}"
WORKSPACE_DIR="${WORKSPACE_DIR:-$PWD/workspace}"
MAX_ITERATIONS="${MAX_ITERATIONS:-50}"

# ─── Проверки ───
command -v docker >/dev/null 2>&1 || { echo "Docker не установлен. См. llm-router/config/docker-agent.md"; exit 1; }
docker info >/dev/null 2>&1 || { echo "Docker daemon не запущен (или недоступен по DOCKER_HOST)."; exit 1; }

# Проверить, что роутер жив
if ! curl -s -m 5 "${ROUTER_BASE_URL}/v1/models" >/dev/null 2>&1; then
  echo "Роутер недоступен по ${ROUTER_BASE_URL}. Запустите OmniRoute."
  exit 1
fi

mkdir -p "${WORKSPACE_DIR}"

# ─── Переменные окружения для OpenHands (LLM_*, SANDBOX_*) ───
export LLM_MODEL="${ROUTER_MODEL}"
export LLM_API_KEY="any-nonempty-value"
export LLM_BASE_URL="${ROUTER_BASE_URL}/v1"
export LLM_TEMPERATURE="0.0"
export LLM_NUM_RETRIES="3"
export LLM_RETRY_MIN_WAIT="5"
export LLM_RETRY_MAX_WAIT="60"
export LLM_DROP_PARAMS="true"
export LLM_MAX_OUTPUT_TOKENS="4000"
export LLM_CUSTOM_LLM_PROVIDER="openai"
export WORKSPACE_BASE="${WORKSPACE_DIR}"
export SANDBOX_TIMEOUT="120"
export SANDBOX_ENABLE_AUTO_LINT="false"
export MAX_ITERATIONS="${MAX_ITERATIONS}"
export RUNTIME="eventstream"

echo "→ Роутер:      ${ROUTER_BASE_URL} (модель ${ROUTER_MODEL})"
echo "→ Docker:      ${DOCKER_HOST}"
echo "→ Workspace:   ${WORKSPACE_DIR}"

# ─── Запуск агента ───
# Директория, из которой запускаем, становится воркспейсом внутри песочницы.
cd "${WORKSPACE_DIR}"

if [ "${1:-}" = "-f" ]; then
  shift
  openhands --task-file "${1:?укажите путь к файлу с задачей}"
else
  openhands --task "${1:?укажите задачу}" --max-iterations "${MAX_ITERATIONS}"
fi
