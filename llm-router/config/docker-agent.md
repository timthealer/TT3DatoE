# Подключение Docker для код-агента (OpenHands)

## Короткий ответ: где нужен Docker?

| Компонент | Нужен ли Docker? | Где запускается |
|---|---|---|
| **Роутер (OmniRoute)** | **НЕТ** — обычный Node.js-процесс | сервер/VPS или этот dev-контейнер |
| **Код-агент (OpenHands)** | **ДА** — выполняет команды в Docker-песочнице | ПК, ноутбук или сервер/VPS |
| **Интерфейс (kurvabobros)** | НЕТ — статический фронтенд | телефон (браузер/WebView) |

**Телефону Docker не нужен.** На Android полноценный Docker не ставится (только Termux + root с серьёзными ограничениями), на iOS — вообще никак. Телефон всегда остаётся **только клиентом** — он открывает веб-интерфейс и ходит по API на ваш сервер.

Docker ставится **отдельно, на машину, где выполняется код-агент** — это ПК/ноутбук или VPS-сервер с Linux.

## Схемы развёртывания

### Схема A: всё на одном сервере (рекомендуется)
```
[Телефон] --HTTPS--> [Сервер/VPS: роутер (без Docker) + OpenHands (Docker) + интерфейс]
```
Docker ставится один раз на сервер. Всё автономно, телефон ничем не управляет.

### Схема B: роутер на сервере, код-агент на вашем ПК
```
[Телефон] --> [Сервер: роутер, интерфейс]
                       ^
[ПК с Docker: OpenHands] --DOCKER_HOST + API--> роутер
```
OpenHands на ПК подключается к удалённому роутеру через его OpenAI-совместимый `/v1` endpoint.
Docker используется локально на ПК — это самый простой вариант, если вы хотите «пощупать» код-агента.

### Схема C: всё на ПК (для разработки)
Роутер + Docker + OpenHands на одной машине. Телефон опционально подключается через публичный URL.

## Как подключить OpenHands к Docker

OpenHands использует стандартную переменную `DOCKER_HOST` (см. `_init_docker_client()` → `docker.from_env()`).

### 1. Docker на той же машине, что и OpenHands (Схема A/C)

```bash
# Проверить, что Docker работает
docker info

# OpenHands сам подхватит сокет по умолчанию — ничего настраивать не нужно
```

### 2. Docker на отдельной машине, OpenHands на другой (удалённый Docker)

На машине с Docker (Ubuntu):

```bash
# Разрешить удалённое подключение (вНИМАНИЕ: открывает 2375 — только для внутренней сети)
sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
  "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]
}
EOF
sudo systemctl restart docker
```

На машине с OpenHands (или в этом dev-контейнере):

```bash
export DOCKER_HOST=tcp://<IP-машины-с-docker>:2375
docker info   # должно ответить удалённому демону
```

### 3. Запуск код-агента OpenHands (headless, через роутер)

Готовый скрипт — `start-code-agent.sh` (проверяет Docker и роутер, выставляет все `LLM_*`/`SANDBOX_*` env):

```bash
./start-code-agent.sh "найди баг в src/index.ts и исправь"
./start-code-agent.sh -f /path/to/task.txt
```

Вручную (без скрипта):

```bash
export LLM_MODEL=oc/deepseek-v4-flash-free
export LLM_API_KEY=any-nonempty-value
export LLM_BASE_URL=http://localhost:20128/v1
export LLM_CUSTOM_LLM_PROVIDER=openai
export WORKSPACE_BASE=$PWD/workspace
export DOCKER_HOST=unix:///var/run/docker.sock
openhands --task "найди баг в src/index.ts и исправь"
```

Конфиг эквивалентен `agent.config.toml` в этой папке. Проверено: OpenHands корректно подхватывает `LLM_*`/`WORKSPACE_*`/`SANDBOX_*` env-переменные (см. `load_from_env` в `openhands/core/config/utils.py`).

## Требования к машине с Docker

- Linux или macOS (Docker Desktop). Windows — WSL2.
- OpenHands тянет runtime-образ `nikolaik/python-nodejs` (~1–2 GB на диске) и собирает свой образ при первом запуске (нужно ещё ~2 GB).
- Рекомендация: от 4 GB RAM, от 10 GB свободного диска.

## Ограничение этой dev-среды

В текущем облачном dev-контейнере Docker не установлен (нет привилегий/systemd), поэтому OpenHands здесь запустить нельзя. Поэтому код-агент реально запускается по Схеме B: OpenHands живёт на вашем ПК с Docker, а роутер уже работает на сервере (порт 20128, публичный URL `https://20128-4e48658a918603a1.monkeycode-ai.live`).
