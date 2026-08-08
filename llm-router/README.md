# llm-router — маршрутизация LLM

Источники: [OmniRoute](https://github.com/diegosouzapw/OmniRoute), [Aegis](https://github.com/DukeDeSouth/aegis).

```
llm-router/
├── auto-combo/   # Автоматический выбор провайдера (OmniRoute)
├── rotation/     # Ротация аккаунтов (OmniRoute)
├── budget/       # Управление бюджетом (Aegis)
└── config/       # Рабочий MVP-конфиг (проверенные бесплатные алиасы, Docker)
```## Что скопировано

- **auto-combo**: `routingStrategies.ts` (19 стратегий, ACCOUNT_FALLBACK_STRATEGY_VALUES),
  `combo.ts` (схема комбо), `freeModels.ts` (бесплатные модели).
- **rotation**: `apiKeyPolicy.ts` (политика ключей), `peerRouting.ts` (устойчивость пиринговой маршрутизации).
- **budget**: `engine.ts` (бюджет как контракт из Aegis), `0009-post-mvp-core-loc-budget.md` (ADR).
- **config**: `free-router.json` (проверенные вживую бесплатные алиасы), `docker-agent.md` (подключение Docker для код-агента), `provider-auth.md` (автоподключение бесплатных провайдеров через OAuth), `agent.config.toml` + `start-code-agent.sh` (запуск OpenHands из коробки).

## Интеграция с TT3Dato

- Рабочий роутер подключён в `TT3DatoE` (вкладка Модели → Свой роутер, OmniRoute `/v1`).
- Алиасы: `auto/best-chat` (стабильный), `auto/best-coding`, fallback на `auto/best-coding` при пустом ответе.

## Проверенные бесплатные алиасы (live-тест 2026-08-08)

| Алиас | Streaming | Non-streaming | Для код-агента |
|---|---|---|---|
| `auto/cheap` | работает (→ big-pickle) | падает (combo retry) | нет |
| `auto/coding:free` | работает (→ big-pickle) | падает (combo retry) | нет |
| `oc/deepseek-v4-flash-free` | работает | **работает** (min max_tokens 200) | **да** |

- `auto/best-free` — сломан («Maximum combo retry limit reached»), использовать `auto/cheap` вместо него.
- Подробности: `config/free-router.json`, `config/docker-agent.md`.
