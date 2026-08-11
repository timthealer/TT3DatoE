> Источник: live-тест связки OmniRoute → Coddy в dev-среде, 2026-08-09. Адаптировано для TT3Dato.

# Шаблон записи памяти (ecc.memory.v1)

---

- id: MEM-0005
- date: 2026-08-09
- scope: project
- source: live-тест coddy 0.9.60, /v1/chat/completions + /v1/responses
- status: verified
- tags: [coddy, код-агент, прототип, omniroute, stream_options, web-ui]

---

# Рабочий веб-прототип: роутер → Coddy → веб-UI (без Docker)

OpenHands снят с роли код-агента. Внедрён **Coddy** (один Go-бинарник, MIT): ReAct-агент с файлами, shell, MCP, skills и **встроенным веб-UI**. Docker не нужен — это сняло главный блокер (раньше OpenHands жёстко требовал Docker-песочницу).

## Контекст

Нужен быстрый рабочий прототип, доступный из браузера. Связка: OmniRoute (:20128) → Coddy (:12345) → встроенный UI. Все доработки делаются из этого же веб-интерфейса.

## Подтверждение

Установка и конфигурация:

- Бинарник: релиз `coddy_0.9.60_linux_amd64.tar.gz` → `/usr/local/bin/coddy`; теги `http ui scheduler memory` (полная сборка).
- Конфиг `/root/.coddy/config.yaml`: `providers.router` (type openai, `api_base: http://localhost:20128/v1`, пустой ключ), модель `router/oc/deepseek-v4-flash-free`, `agent.max_turns: 35`.
- Запуск: `coddy http -P 12345` (фон, терминал `term_1786300676154_22`). Превью: `https://12345-4e48658a918603a1.monkeycode-ai.live`.

Проверки связки (все 200):

- `/v1/models` на coddy отдаёт `router/oc/deepseek-v4-flash-free` (проксирует роутер).
- Streaming: `POST /v1/responses` `{"stream":true}` → отвечает (это путь UI).
- Non-streaming: `POST /v1/chat/completions` → отвечает «Да» после патча.

**Патч Coddy (критично)**: провайдеры OmniRoute отвечают 400 `stream_options should be set along with stream = true`, если `stream_options` приходит без `stream=true`. Coddy 0.9.60 слал `stream_options` и в non-streaming (зашито в общей `buildParams`, openai.go). Патч: перенести `params.StreamOptions` из `buildParams` в `Stream()` (только streaming). Источник патча: `/tmp/opencode/coddy-src/` (клон), собран в `build/coddy`, установлен в `/usr/local/bin/coddy`.

Артефакты репозитория (обновлены):

- `deploy/docker-compose.yml` — agent = `ghcr.io/coddy-project/coddy-agent:latest`, порт 12345, volume `coddy-data`, конфиг маунтится в `/etc/coddy/config.yaml`.
- `deploy/agent/coddy-config.example.yaml` — шаблон конфига.
- `deploy/agent/start-coddy.sh` — запуск через `ROUTER_BASE_URL`.
- `deploy/.env.example` — `ROUTER_BASE_URL`, `ROUTER_API_KEY`, `AGENT_PORT` вместо OpenHands-переменных.
- `deploy/deploy.sh` — проверка веб-UI агента и моделей.
- `README.md` — шаги 5–8 переписаны под Coddy; таблица сервисов и схем обновлена.
- `llm-router/config/docker-agent.md` — переписан: Coddy без Docker, OpenHands снят с замены.

## Последствия

- Прототип работает **без VPS/Docker**: роутер + coddy как процессы на любой машине; UI открывается с телефона и ПК по превью-ссылке.
- Docker теперь нужен только для опционального `deploy/` (compose-схема «одно приложение») — и то это выбор, а не необходимость.
- Модель по умолчанию: `oc/deepseek-v4-flash-free` (бесплатная non-streaming, reasoning).
- Доступ без авторизации: coddy http на 0.0.0.0:12345 без `auth_token` (WARN в логах). Для публичного доступа задать `CODDY_HTTP_TOKEN`.
- MCP: `mcp.project_trust: ask` — локальные `.coddy/mcp.json` требуют подтверждения (безопасность по умолчанию).
- Fallback-каскад и автоконтекст из TT3DatoE применимы как клиентский слой поверх Coddy API.

## Продвижение

