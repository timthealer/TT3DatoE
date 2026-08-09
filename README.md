# TT3Dato — автономный AI-агент

MVP автономного AI-агента: свой **бесплатный LLM-роутер** + **код-агент** (Coddy), работающие без собственных API-ключей. Роутер подключает бесплатные провайдеры автоматически (OAuth), а код-агент выполняет задачи в своём workspace с встроенным веб-интерфейсом.

```
TT3Dato/
├── llm-router/   # Роутер: конфиг, автоподключение провайдеров, запуск код-агента
├── core/         # Память, swarm, federation, trust-domains
├── agents/       # Спецификации и форматы агентов
├── tools/        # Инструменты (browser, filesystem, shell)
├── Memory/       # Проверенные факты (память проекта)
└── docs/         # Документация и обзоры
```

---

## Пошаговая установка и подключение

### Шаг 1. Клонировать репозиторий

```bash
git clone https://github.com/timthealer/TT3Dato.git
cd TT3Dato
```

### Шаг 2. Установить и запустить роутер (OmniRoute)

Роутер — Node.js-процесс, Docker ему не нужен.

```bash
npm install -g omniroute
omniroute start
```

Проверить, что роутер жив и отдаёт модели:

```bash
curl http://localhost:20128/v1/models
```

Ожидается JSON со списком из 120+ моделей, включая бесплатные алиасы.

> Порт по умолчанию — 20128. Если запускаете на отдельном сервере, откройте порт в файрволе и укажите публичный URL в конфиге (`OMNIROUTE_PUBLIC_BASE_URL`).

### Шаг 3. Подключить бесплатных провайдеров (автоматически, без ключей)

OmniRoute умеет подключать бесплатных провайдеров через OAuth — API-ключи не нужны.

```bash
# Список доступных провайдеров
omniroute oauth providers

# Пример: подключить Google Gemini (откроется браузер с URL для авторизации)
omniroute oauth start --provider gemini --no-browser

# Пример: GitHub Copilot (device-код, без браузера на сервере)
omniroute oauth start --provider copilot
```

Доступно: `gemini`, `antigravity`, `windsurf`, `qwen`, `cursor`, `zed`, `kiro`, `claude-code`, `codex`, `copilot`. Подробности — `llm-router/config/provider-auth.md`.

Проверить подключения:

```bash
omniroute providers list
omniroute providers test-all
```

### Шаг 4. Проверить бесплатные модели

```bash
curl http://localhost:20128/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"oc/deepseek-v4-flash-free","messages":[{"role":"user","content":"ping"}],"max_tokens":200,"stream":false}'
```

Рабочие бесплатные алиасы (проверено вживую):

| Алиас | Streaming | Non-streaming | Для код-агента |
|---|---|---|---|
| `auto/cheap` | работает | нет | нет |
| `auto/coding:free` | работает | нет | нет |
| `oc/deepseek-v4-flash-free` | работает | работает | **да** |

### Шаг 5. Установить код-агент (Coddy)

Код-агент — **Coddy** (один Go-бинарник: ReAct-цикл, файлы, shell, MCP, встроенный веб-UI). В отличие от OpenHands ему **не нужна Docker-песочница** — он работает как обычный процесс и ходит в роутер по `/v1`.

```bash
curl -fsSL https://coddy.dev/install.sh | bash
coddy -v
```

### Шаг 6. Настроить подключение к роутеру

Создайте `~/.coddy/config.yaml` (шаблон: `deploy/agent/coddy-config.example.yaml`):

```yaml
providers:
  - name: router
    type: openai
    api_base: "http://localhost:20128/v1"
    api_key: "${ROUTER_API_KEY:-}"

models:
  - model: "router/oc/deepseek-v4-flash-free"

agent:
  model: "router/oc/deepseek-v4-flash-free"
  max_turns: 35
```

### Шаг 7. Запустить код-агента (веб-интерфейс)

```bash
coddy http -P 12345
```

Откройте **http://localhost:12345** — встроенный чат-UI (agent/plan режимы, история, настройки). Этот же интерфейс доступен по публичной ссылке, если порт открыт наружу. Все доработки агента можно делать прямо из браузера.

Результаты работы агента появляются в рабочей директории (по умолчанию — каталог запуска).

### Шаг 8. Готовый веб-прототип (уже развёрнут)

Рабочий прототип собран: **роутер (OmniRoute) → код-агент (Coddy) → встроенный веб-UI**. Достигнуто:

- Один процесс агента — без Docker-песочницы (Coddy работает в workspace напрямую).
- Веб-интерфейс с чатом, файлами, MCP, историей — открывается в браузере (agent/plan режимы).
- Связка проверена: streaming (`/v1/responses`) и non-streaming (`/v1/chat/completions`) оба отвечают через роутер моделью `oc/deepseek-v4-flash-free`.

---

## Типовые схемы развёртывания

| Схема | Где роутер | Где агент (Coddy) | Когда нужна |
|---|---|---|---|
| A. Всё на одном сервере | VPS | VPS | автономный круглосуточный агент |
| B. Роутер на сервере, агент на ПК | VPS | ваш ПК | быстрый старт, «пощупать» |
| C. Всё на ПК | ваш ПК | ваш ПК | разработка |

Телефон в любой схеме — только клиент (встроенный веб-UI Coddy на :12345).

---

## Частые проблемы

- **`auto/best-free` не работает** — известный баг комбо («Maximum combo retry limit reached»). Используйте `auto/cheap` или `oc/deepseek-v4-flash-free`.
- **Пустой ответ от бесплатной reasoning-модели** — увеличьте `max_tokens` до 200+ (reasoning съедает лимит).
- **Coddy отвечает `stream_options should be set along with stream = true`** — известная несовместимость с OmniRoute: `stream_options` валиден только со `stream=true`, а Coddy слал его и в non-streaming. Исправлено патчем (бинарник из `deploy/agent`/пересборка из `coddy-src`).
- **Coddy не видит роутер** — проверьте `api_base` в `~/.coddy/config.yaml` и `curl localhost:20128/v1/models`.

Подробности: `deploy/agent/coddy-config.example.yaml`, `llm-router/config/free-router.json`, `llm-router/config/provider-auth.md`.

---

## Развёртывание одним приложением (Фаза 1)

Всё поднимается **на одном сервере одним docker-compose**: роутер + код-агент + веб-интерфейс. Телефон — только клиент.

```bash
cd deploy
cp .env.example .env      # заполнить секреты (JWT_SECRET, API_KEY_SECRET, STORAGE_ENCRYPTION_KEY)
./deploy.sh               # поднять всё и проверить связность
./deploy.sh status        # статус и повторная проверка
./deploy.sh down          # остановить
```

Сервисы (`deploy/docker-compose.yml`):

| Сервис | Образ | Порт | Назначение |
|---|---|---|---|
| `router` | `diegosouzapw/omniroute:latest` | 20128 | LLM-роутер (бесплатные алиасы, OAuth-автоподключение) |
| `redis` | `redis:8.6.5-alpine` | — | rate-limiter роутера |
| `agent` | `ghcr.io/coddy-project/coddy-agent:latest` | 12345 | код-агент (ReAct+MCP, встроенный веб-UI) |
| `ui` | `nginx:alpine` | 3000 | веб-интерфейс (опционально) |

`deploy.sh` сам проверяет: ответ роутера `/v1/models`, работу бесплатной non-streaming модели, веб-UI код-агента и веб-интерфейс.

> Требования к VPS: Linux, Docker + compose plugin, от 2 GB RAM (Coddy лёгкий, в отличие от OpenHands), от 10 GB диска.
