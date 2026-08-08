# TT3Dato — автономный AI-агент

MVP автономного AI-агента: свой **бесплатный LLM-роутер** + **код-агент** (OpenHands), работающие без собственных API-ключей. Роутер подключает бесплатные провайдеры автоматически (OAuth), а код-агент выполняет задачи в Docker-песочнице.

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

### Шаг 5. Установить Docker (только для код-агента)

Роутеру Docker не нужен. Docker нужен **только** код-агенту (OpenHands) — он выполняет команды в Docker-песочнице.

- Устанавливается **отдельно на ПК или VPS** (Linux/macOS; Windows — WSL2).
- На телефоне полноценный Docker не ставится — телефон остаётся только клиентом.
- Требования: от 4 GB RAM, от 10 GB свободного диска.

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | sh
docker info   # проверить, что демон запущен
```

### Шаг 6. Установить код-агент (OpenHands)

```bash
pip install e2b==0.17.1     # обход конфликта зависимостей (e2b<0.18 удалён с PyPI)
pip install openhands-ai
```

### Шаг 7. Запустить код-агента

Используйте готовый скрипт — он проверит Docker и роутер и выставит все переменные:

```bash
cd TT3Dato
./llm-router/config/start-code-agent.sh "найди баг в src/index.ts и исправь"
```

Или с задачей из файла:

```bash
./llm-router/config/start-code-agent.sh -f /path/to/task.txt
```

Переменные можно переопределить:

```bash
ROUTER_BASE_URL=http://server:20128 ROUTER_MODEL=oc/deepseek-v4-flash-free \
  ./llm-router/config/start-code-agent.sh "задача"
```

Результат работы агента появится в `TT3Dato/workspace/`.

---

## Типовые схемы развёртывания

| Схема | Где роутер | Где Docker (код-агент) | Когда нужна |
|---|---|---|---|
| A. Всё на одном сервере | VPS | VPS | автономный круглосуточный агент |
| B. Роутер на сервере, агент на ПК | VPS | ваш ПК | быстрый старт, «пощупать» |
| C. Всё на ПК | ваш ПК | ваш ПК | разработка |

Телефон в любой схеме — только клиент (веб-интерфейс).

---

## Частые проблемы

- **`auto/best-free` не работает** — известный баг комбо («Maximum combo retry limit reached»). Используйте `auto/cheap` или `oc/deepseek-v4-flash-free`.
- **Пустой ответ от бесплатной reasoning-модели** — увеличьте `max_tokens` до 200+ (reasoning съедает лимит).
- **OpenHands не стартует** — проверьте, что Docker запущен (`docker info`) и роутер отвечает (`curl localhost:20128/v1/models`).
- **Ошибка установки openhands-ai** — сначала поставьте `e2b==0.17.1`, затем `openhands-ai`.

Подробности: `llm-router/config/docker-agent.md`, `llm-router/config/free-router.json`, `llm-router/config/provider-auth.md`.
