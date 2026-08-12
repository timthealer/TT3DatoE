> Источник: восстановление стека TT3Dato после пересоздания dev-среды, 2026-08-12.

# Шаблон записи памяти (ecc.memory.v1)

---

- id: MEM-0007
- date: 2026-08-12
- scope: project
- source: live-восстановление в пересозданной dev-среде (omniroute 3.8.48, coddy 0.9.61)
- status: verified
- tags: [session-reset, omniroute, coddy, oauth, antigravity, 429, fallback, tailscale]

---

# Session reset: восстановление стека роутер → Coddy с нуля

Dev-среда была пересоздана: роутер, Coddy, OAuth-подключения и конфиги пропали.
Ниже — как поднять стек заново и что изменилось по сравнению с MEM-0003/MEM-0005.

## Контекст

После пересоздания среды не оказалось: `omniroute`, `coddy`, `/root/.coddy/`,
`/root/.omniroute/`, а также MEM-0007 (session-reset) как файла. Восстановление
нужно для главной задачи: автопереключение между моделями/провайдерами, чтобы
код-агент не падал с 429 и обрывами стрима. План — переезд на ноут через Tailscale.

## Подтверждение

Установка и запуск (всё проверено, работает):

- `npm install -g omniroute` → CLI 3.8.48 (важно: не путать с внутренней версией
  процесса «omniroute (v16…» — это версия ядра, npm-пакет 3.8.x).
- `curl -fsSL https://coddy.dev/install.sh | bash` → coddy 0.9.61 в `/root/.local/bin`.
- Роутер: `omniroute serve --no-open --no-tray` (фон) → `http://localhost:20128/v1`,
  99 моделей, алиасы `auto/cheap`, `auto/coding:free`, `oc/deepseek-v4-flash-free` на месте.
- Конфиг Coddy: `/root/.coddy/config.yaml` → провайдер `router` (openai,
  `api_base: http://localhost:20128/v1`, пустой ключ), модель `router/oc/deepseek-v4-flash-free`,
  `agent.max_turns: 35`, `permission_mode: bypass` (для автономности), `project_trust: ask`.
- Запуск Coddy: `coddy http -P 12345` (фон). `/v1/models` отдаёт
  `router/oc/deepseek-v4-flash-free`. Non-streaming (`/v1/chat/completions`) и
  streaming (`/v1/responses`) отвечают. UI: превью `https://12345-e7ff723b18354918.monkeycode-ai.live`.

Проверка моделей (2026-08-12):

- `oc/deepseek-v4-flash-free` — non-streaming + streaming работают (были 200 в начале сессии).
- К вечеру сессии: `[429] Error from provider (Console): Rate limit exceeded` —
  лимит исчерпан, это и есть целевая проблема для автопереключения.
- `oc/big-pickle` — тоже 429. Остальные `oc/*-free` → 401 без OAuth-провайдеров.
- Без OAuth-провайдеров стабилен только `oc/deepseek-v4-flash-free` (non-streaming).

OAuth-статус:

- CLI: `omniroute connect http://localhost:20128 --scope admin` (пароль INITIAL_PASSWORD)
  → контекст `localhost` (admin-токен `oma_live_…`) в `/root/.omniroute/config.json`.
- Дашборд-вход: `POST /api/auth/login {"password":"CHANGEME"}` → cookie (JWT).
- Баг CLI: `omniroute oauth start --provider antigravity` шлёт на `/api/oauth/antigravity/start`,
  а сервер (v3.8.48) поддерживает только `/authorize` (динамический роут
  `/api/oauth/[provider]/[action]`, actions: authorize/exchange/device-code/…).
  Официальный путь для remote/headless: `omniroute login antigravity` на ноуте
  пользователя → credential-blob → `POST /api/oauth/antigravity/paste-credentials`
  (или дашборд Providers → Antigravity → «Paste credentials»).
- OAuth-подключения при пересоздании среды теряются (SQLite `storage.sqlite` в `/root/.omniroute/`).

## Последствия

- Поднять стек после reset можно за ~10 минут по шагам выше.
- Для antigravity на remote-установке использовать `omniroute login antigravity`
  + paste-credentials, а не `oauth start` (несовместим с 3.8.48).
- Автопереключение: без OAuth-провайдеров fallback-цепочка пуста (кроме
  `oc/deepseek-v4-flash-free`). Нужны OAuth-провайдеры (antigravity и др.),
  чтобы каскад `auto/*` имел запасные цели против 429/обрывов стрима.
- Tailscale-план: роутер и агент переедут на ноут; конфиги и бинарники —
  `/root/.omniroute/`, `/root/.coddy/`, `/root/.local/bin/coddy`.
- KurvaBobrOS откачен (пользователю не зашёл, визуал вторичен) — не разворачивать снова.

## Продвижение

Шаги установки закреплены в корневом `README.md` (шаги 1–8). Факт несовместимости
`oauth start` и пути paste-credentials стоит продвинуть в `packages/llm-router/config/provider-auth.md`.
