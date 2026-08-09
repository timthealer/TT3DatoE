# Код-агент: Coddy (без Docker) — как подключать

Обновлено после внедрения Coddy: **код-агенту больше не нужен Docker**. Раньше
роль код-агента играл OpenHands, который жёстко требовал Docker-песочницу
(`docker.from_env()`). Coddy — один Go-бинарник, работает как обычный процесс
в своём workspace и ходит в роутер по OpenAI-совместимому `/v1`.

## Короткий ответ: где нужен Docker?

| Компонент | Нужен ли Docker? | Где запускается |
|---|---|---|
| **Роутер (OmniRoute)** | **НЕТ** — обычный Node.js-процесс | сервер/VPS или dev-контейнер |
| **Код-агент (Coddy)** | **НЕТ** — обычный процесс (Go-бинарник) | сервер/VPS, ПК — где угодно |
| **Интерфейс** | НЕТ — встроенный веб-UI Coddy на :12345 | любой браузер (телефон/ПК) |

**Телефону ничего не нужно** — он открывает веб-UI Coddy и общается с агентом через браузер.

## Установка

```bash
curl -fsSL https://coddy.dev/install.sh | bash
coddy -v
```

Полная сборка включает теги `http ui scheduler memory` (веб-UI, планировщик, память).

## Конфигурация (`~/.coddy/config.yaml`)

```yaml
providers:
  - name: router
    type: openai
    api_base: "http://localhost:20128/v1"
    api_key: "${ROUTER_API_KEY:-}"

models:
  - model: "router/oc/deepseek-v4-flash-free"
    max_tokens: 8192
    temperature: 0.2

agent:
  model: "router/oc/deepseek-v4-flash-free"
  max_turns: 35
```

## Запуск

```bash
coddy http -P 12345
# веб-UI: http://localhost:12345
# API:     /v1/models, /v1/chat/completions, /v1/responses (streaming)
```

## Особенности интеграции с OmniRoute

- **Провайдер**: `type: openai` + `api_base` на роутер. Поле `api_key` можно
  оставить пустым, если роутер открыт (`REQUIRE_API_KEY=false`).
- **Модель**: формат `<provider>/<router-model-id>`, т.е. `router/oc/deepseek-v4-flash-free`.
- **Streaming**: Coddy использует `/v1/responses` (stream=true) — работает.
- **Non-streaming**: `/v1/chat/completions` (stream=false) — работает.
- **Известный патч (важно)**: Coddy до 0.9.60 слал `stream_options` даже в
  non-streaming запросах; провайдеры OmniRoute отвечают
  `stream_options should be set along with stream = true`. Исправлено патчем:
  `stream_options` теперь шлётся только при `stream=true`
  (`internal/llm/openai.go` в `/tmp/opencode/coddy-src/`). Если соберёте бинарник
  сами — примените тот же патч.

## Схемы развёртывания

```
A. Всё на одном сервере:  [Телефон] --HTTPS--> [VPS: роутер + coddy http :12345]
B. Роутер на сервере, агент на ПК:  coddy на ПК, api_base=http://server:20128/v1
C. Всё на ПК:  роутер + coddy локально
```

## Что было раньше (OpenHands — снят с замены)

- OpenHands требует Docker-песочницу: `pip install e2b==0.17.1` + `pip install openhands-ai`.
- Подключение через `LLM_BASE_URL` + `LLM_CUSTOM_LLM_PROVIDER=openai`; `DOCKER_HOST` для удалённого демона.
- Оставлен `start-code-agent.sh` и `agent.config.toml` как исторический вариант — больше не рекомендуются.
