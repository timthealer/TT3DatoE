# TT3Dato Awesome — курируемый каталог решений

> Курация, а не коллекция. Только то, что лично рекомендовано и проверено.
> Формат адаптирован из [sindresorhus/awesome](https://github.com/sindresorhus/awesome) (методология курируемых списков).

## Принципы

1. **Только awesome** — каждый пункт рекомендован и проверен в TT3Dato или прошёл аудит.
2. **Лучше пропустить, чем включить лишнее** — курация строже коллекции.
3. **Каждая запись — из источника** — указан репозиторий, статус, что взяли.
4. **PR-модель** — новые кандидаты добавляются только после исследования (минимум 5 альтернатив, Конституция, раздел 4).

## Статусы

- **ACTIVE** — используется как источник и поддерживается.
- **CANDIDATE** — рассматривается для интеграции.
- **MONITORING** — наблюдаем, внедрение отложено.
- **RETIRED** — отклонено.

## Ядро системы

- [Aegis](https://github.com/DukeDeSouth/aegis) — MONITORING. Trust-домены, верифицируемая память, карантин ввода, бюджет-контракты. `packages/core/trust-domains/`, `packages/core/memory/`.
- [Ruflo](https://github.com/ruvnet/ruflo) — ACTIVE. Федерация агентов, рои, SONA-память, MCP. `packages/core/swarm/`, `packages/core/federation/`.

## Маршрутизация LLM

- [OmniRoute](https://github.com/diegosouzapw/OmniRoute) — CANDIDATE. ~290 провайдеров, 19 стратегий маршрутизации, комбо, ротация аккаунтов, budget-cap. `packages/llm-router/`.

## Агенты и инструменты

- [Atomic Agent](https://github.com/Doriandarko/atomic-agent) — CANDIDATE. Local-first, ARIA-браузер, tracing (append-only). `packages/tools/browser/`, `packages/traces/`.
- [ECC](https://github.com/affaan-m/ECC) — ACTIVE. Цикл, навыки, агенты, memory vault. `agents/`, `agents/skills/`.

## Документация

- [awesome](https://github.com/sindresorhus/awesome) — ACTIVE. Методология курируемых списков, критерии качества. Этот каталог.

## Методология пополнения

1. Кандидат попадает в `docs/OpenSourceRegistry.md` после сканирования.
2. Досье создаётся в `docs/repositories/<Repo>/dossier.md`.
3. Проверка через агентов (Researcher/Auditor).
4. Решение о статусе — только после проверки.
