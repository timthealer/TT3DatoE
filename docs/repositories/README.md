# Repositories

Библиотека системы TT3Dato — каталог open-source репозиториев, используемых как источники методологий и решений (Конституция, раздел 10: «GitHub является библиотекой системы»).

## Структура

```
docs/repositories/
  README.md               # этот файл
  stack-mappings.json     # маппинг «задача TT3Dato -> репозиторий-решение»
  inventory.json          # инвентарь агентов и навыков TT3Dato
  <RepoName>/             # досье на репозиторий (метаданные + статус)
```

## Статусы репозиториев

- ACTIVE — используется как источник и поддерживается;
- CANDIDATE — рассматривается для интеграции;
- MONITORING — наблюдаем, внедрение отложено;
- RETIRED — отклонено.

## Текущий каталог

| Репозиторий | Статус | Что взяли |
|---|---|---|
| `Ruflo` | ACTIVE | Методология Researcher и Auditor (агенты), федерация, рои, SONA-память (packages/core/swarm, packages/core/federation) |
| `ECC` | ACTIVE | Цикл, skills, агенты, rules, memory, security (см. docs/ATTRIBUTIONS.md) |
| `OmniRoute` | CANDIDATE | AI-шлюз, стратегии маршрутизации, комбо, ротация (packages/llm-router/) |
| `Aegis` | MONITORING | Trust-домены, верифицируемая память, бюджет-контракты (packages/core/trust-domains, packages/core/memory, packages/llm-router/budget) |
| `atomic-agent` | CANDIDATE | Local-first, ARIA-браузер, tracing (packages/tools/browser, packages/tools/filesystem, packages/tools/shell, packages/traces/) |
| `awesome` | ACTIVE | Методология курируемых списков (docs/awesome.md) |

## Правила добавления

1. Новый репозиторий добавляется только после исследования (минимум 5 альтернатив, Конституция, раздел 4).
2. Запись вносится в `stack-mappings.json` и создаётся досье `<RepoName>/`.
3. Все заимствования фиксируются в `docs/ATTRIBUTIONS.md`.
