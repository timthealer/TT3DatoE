> Источник: live-тест OmniRoute v16.2.10 в dev-среде, анализ OpenHands 0.9.8. Адаптировано для TT3Dato.

# Шаблон записи памяти (ecc.memory.v1)

---

- id: MEM-0003
- date: 2026-08-08
- scope: project
- source: live-тест /v1/chat/completions, openhands-ai 0.9.8 (pip)
- status: verified
- tags: [llm-router, omniroute, бесплатные-модели, openhands, docker]

---

# Проверенные бесплатные алиасы роутера и ограничение Docker

Сводка verified-фактов о бесплатном LLM-доступе через OmniRoute и о код-агенте OpenHands.

## Контекст

Для MVP автономного агента нужен бесплатный LLM-доступ и код-агент. OmniRoute уже запущен на :20128 с 122 моделями; openhands-ai установлен для роли код-агента.

## Подтверждение

Live-тесты через `curl /v1/chat/completions` (2026-08-08):

- `auto/cheap` и `auto/coding:free` — работают **только в streaming** (ведут на big-pickle). В non-streaming падают: «Maximum combo retry limit reached».
- `oc/deepseek-v4-flash-free` — работает в **non-streaming** (это требование код-агентов). Reasoning-модель: content приходит только при `max_tokens >= 200` (reasoning съедает бюджет).
- `auto/best-free` — сломан (exhausted: auggie, chipotle).
- `auto/best-chat`, `auto/best-coding` — рабочие (из более ранних проверок).

Анализ кода OpenHands 0.9.8:

- EventStreamRuntime (`runtime/client/runtime.py`) жёстко требует Docker: `docker.from_env()`. Локальной песочницы без Docker нет.
- `docker.from_env()` уважает `DOCKER_HOST` — возможен удалённый Docker daemon.
- Конфиг читается через env-переменные (`LLM_MODEL`, `LLM_BASE_URL`, `LLM_API_KEY`, `LLM_CUSTOM_LLM_PROVIDER`, `WORKSPACE_BASE`, `SANDBOX_*`, `MAX_ITERATIONS`, `RUNTIME`) — проверено: все подхватываются.
- Установка: `pip install openhands-ai` конфликтует из-за e2b<0.18 (удалён с PyPI); обход: `pip install e2b==0.17.1`, затем `pip install openhands-ai`.

OAuth-автоподключение бесплатных провайдеров встроено в OmniRoute: `omniroute oauth start --provider <id>` (gemini, antigravity, windsurf, qwen, cursor, zed, kiro, claude-code, codex, copilot). `antigravity` уже подключён (timthealer@gmail.com).

## Последствия

- Для код-агента использовать `oc/deepseek-v4-flash-free` (единственная проверенная non-streaming бесплатная модель).
- Код-агент OpenHands запускается только на машине с Docker (ПК или VPS), не в этой dev-среде и не на телефоне.
- Maxun для автоподключения провайдеров не обязателен — OAuth встроен в OmniRoute.
- Артефакты: `llm-router/config/free-router.json`, `docker-agent.md`, `provider-auth.md`, `agent.config.toml`, `start-code-agent.sh`.

## Продвижение

Факты закреплены как конфигурация и документация в `llm-router/config/` (коммиты cea3770, 618b098, 215baec). Если станет правилом — продвинуть в governed-документ (Конституция раздел 9).
