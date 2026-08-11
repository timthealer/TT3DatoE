# Empty Directories Fill Analysis

**Репозитории сравнения:** ECC (affaan-m/ECC), Aegis (DukeDeSouth/aegis), Ruflo (ruvnet/ruflo)
**Дата анализа:** 2026-08-01
**Аудитор:** Huckleberry Finn (архитектор TT3Dato)
**Статус:** Ожидает решения пользователя (Decision Protocol)

---

# 1. Наши пустые папки и их предназначение

| Папка | Предназначение (из структуры TT3Dato) |
|---|---|
| `docs/adr/` | Архитектурные чертежи, ADR, планы развития |
| `docs/repositories/` | Библиотека системы: каталог и досье open-source репозиториев (Конституция, раздел 10) |
| `apps/` | Внешние интеграции и коннекторы |
| `docs/workflows/` | Определения агентных рабочих процессов |
| `Temp/` | Временные данные/эксперименты |

---

# 2. Схожие директории в ECC, Aegis, Ruflo

## 2.1. Аналог docs/adr/

| Репозиторий | Директория | Содержимое |
|---|---|---|
| Aegis | `docs/adr/` | ADR 0001-0006: four-trust-domains, verifiable-memory, declarative-skills-first, credential-broker, quarantine-untrusted-input, core-language-and-sandbox-runtime |
| Aegis | `docs/` | ARCHITECTURE.md, TRUST_DOMAINS.md, MEMORY_SCHEMA.md, THREAT_MODEL.md, TOKEN_ECONOMY.md, MVP_SCOPE.md, BACKLOG.md |
| ECC | `docs/design/` | ecc-memory-vault.md, plan-canvas.md, agent-proximity.md |
| ECC | `docs/` | PLAN-PRD-PATTERN.md, SELECTIVE-INSTALL-DESIGN.md, ECC-2.0-REFERENCE-ARCHITECTURE.md |
| Ruflo | `docs/` | IMPROVEMENT-ROADMAP.md, STATUS.md, benchmarks/ |

## 2.2. Аналог docs/repositories/

| Репозиторий | Директория | Содержимое |
|---|---|---|
| ECC | `research/` | ecc2-codebase-analysis.md (анализ кодовой базы) |
| ECC | `config/` | project-stack-mappings.json (маппинг стек->проекты), github-native-coordination.json |
| Ruflo | `verification/` | inventory.json, CAPABILITIES.md, cli-mcp-tool-baseline.json (инвентарь возможностей) |
| Ruflo | `data/` | clone-data.ledger.json, clone-data.proof.json |
| Aegis | `docs/` | REPO_LAYOUT.md (карта структуры репозитория) |

## 2.3. Аналог apps/

| Репозиторий | Директория | Содержимое |
|---|---|---|
| Aegis | `connectors/` | Формат коннектора: `SKILL.md` + `manifest.json` + `connector.json` + `server/server.mjs`. Примеры: bookmarks, caldav, content-calendar |
| ECC | `integrations/` | aura: `adapter.py` + `README.md` + `THREAT_MODEL.md` + `tests/` |
| Ruflo | `services/` | cognitum-analytics (сервис аналитики) |

## 2.4. Аналог docs/workflows/

| Репозиторий | Директория | Содержимое |
|---|---|---|
| Ruflo | `.claude/commands/workflows/` | development.md, research.md, workflow-create.md, workflow-execute.md, workflow-export.md |
| Ruflo | `.claude/workflows/` | full-system-test.js |
| Ruflo | `v3/@claude-flow/agents/` | Готовые процессы: architect.yaml, coder.yaml, reviewer.yaml, tester.yaml, security-architect.yaml |
| ECC | `workflows/` | orch-review.workflow.js + README.md |
| Aegis | `docs/` | LEARNING_LOOP.md (цикл обучения), SKILLS_MODEL.md |

## 2.5. Аналог Temp/

| Репозиторий | Директория | Содержимое |
|---|---|---|
| ECC | `examples/` | Сценарии проверки: evaluator-rag-prototype (candidate-playbook.md, report.json, trace.json) |
| Ruflo | `data/` | ledgers/proof-файлы (временные данные) |
| Aegis | `docs/` | BACKLOG.md (идеи на потом) |

Прямого аналога «Temp» нет ни у одного — по определению это временная область.

---

# 3. Сопоставление с целями TT3Dato

Миссия TT3Dato (Конституция, раздел 1): аудит компаний, поиск рутинных процессов, автоматизация, проектирование AI-агентов, управление знаниями, саморазвитие.

| Наша папка | Какая цель TT3Dato закрывается | Наиболее подходящий источник |
|---|---|---|
| `docs/adr/` | Архитектурные решения и планы | Aegis `docs/adr/` (ADR-формат) + ECC `docs/adr/PLAN-PRD-PATTERN.md` |
| `docs/repositories/` | Управление знаниями / библиотека open-source | ECC `config/project-stack-mappings.json` + Ruflo `verification/inventory.json` |
| `apps/` | Интеграция внешних решений (OmniRoute, GitHub App, Telegram) | Aegis `connectors/` (декларативный формат) + ECC `integrations/` |
| `docs/workflows/` | Автоматизация процессов и аудита | Ruflo `.claude/commands/workflows/` + ECC `workflows/orch-review.workflow.js` |
| `Temp/` | Временные данные экспериментов | Не заполнять; добавить в `.gitignore` |

---

# 4. Предложения, чем заполнить папки

## docs/adr/ — ADR + шаблоны планов

1. Ввести формат ADR (из Aegis `docs/adr/`) и создать первые записи:
   - `0001-four-trust-domains-candidate.md` (trust-домены, кандидат Aegis);
   - `0002-verifiable-memory-candidate.md`;
   - `0003-ecc-cycle.md` (уже в Конституции, раздел 15);
   - `0004-omniroute-integration.md` (после MVP).
2. Скопировать и адаптировать `PLAN-PRD-PATTERN.md` (ECC) как шаблон планов для агента Planner.

## docs/repositories/ — каталог библиотеки

1. `docs/repositories/README.md` — описание каталога.
2. `docs/repositories/stack-mappings.json` — адаптация `project-stack-mappings.json` (ECC): маппинг «задача TT3Dato -> репозиторий-решение».
3. `docs/repositories/inventory.json` — адаптация Ruflo `verification/inventory.json`: инвентарь доступных агентов и навыков TT3Dato.
4. Папки-досье кандидатов: `docs/repositories/ECC/`, `docs/repositories/OmniRoute/`, `docs/repositories/Aegis/`, `docs/repositories/Ruflo/` — ссылки на `docs/research/*` + статус (ACTIVE/CANDIDATE/MONITORING).

## apps/ — коннекторы и интеграции

1. Принять декларативный формат коннектора Aegis (`manifest.json` + `SKILL.md` + `connector.json`).
2. Создать `apps/README.md` с политикой интеграций (по образцу ECC `integrations/aura/README.md` + `THREAT_MODEL.md`).
3. Первые заготовки-манифесты: `apps/omniroute-gateway/manifest.json` (после MVP), `apps/telegram-client/owner-bot/` (кандидат, по Aegis `deploy/broker/telegram`-паттерну).

## docs/workflows/ — агентные процессы

1. Адаптировать цикл из Конституции (раздел 15) в конкретные workflow-файлы:
   - `docs/workflows/development.md` (из Ruflo `.claude/commands/workflows/development.md`);
   - `docs/workflows/research.md` (из Ruflo `.claude/commands/workflows/research.md`);
   - `docs/workflows/review.md` (из ECC `workflows/orch-review.workflow.js` — оркестрация ревью).
2. `docs/workflows/README.md` — описание и правила создания workflow.

## Temp/ — не заполнять

- Добавить `Temp/` в `.gitignore` (временная область). Ни у одного из репозиториев нет смыслового аналога.

---

# 5. Оценка достоверности

**High** — структуры директорий получены напрямую из GitHub API (recursive trees) трёх репозиториев; соответствие целям TT3Dato выверено по Конституции.

---

# 6. Варианты объёма (Decision Protocol)

## Вариант A — Заполнить все 5 папок (рекомендуется)

docs/adr (4 ADR + шаблон плана), docs/repositories (README + 2 JSON-каталога + 4 досье), apps (README + политика), docs/workflows (3 workflow + README), Temp в .gitignore.

- Плюсы: структура становится осмысленной; закрыты роли Planner, ChiefOfStaff, DocumentationManager.
- Минусы: ~15-20 файлов, требуется адаптация каждого.

## Вариант B — Минимальный (Blueprint + Workflows)

Заполнить только docs/adr (ADR-формат) и docs/workflows (цикл ECC в файлах). Остальное — в Roadmap.

- Плюсы: сразу фиксирует решения и процесс; мало файлов.
- Минусы: docs/repositories и apps остаются пустыми.

## Вариант C — Только README-заглушки

В каждую папку — только README с описанием назначения и ссылкой на источники.

- Плюсы: минимум работы, структура документирована.
- Минусы: не перенимается содержимое.

---

# 7. Источники

1. https://github.com/affaan-m/ECC (tree: docs/design, workflows, integrations, config, examples, research)
2. https://github.com/DukeDeSouth/aegis (tree: docs/adr, connectors, deploy, docs, skills)
3. https://github.com/ruvnet/ruflo (tree: .claude/workflows, .claude/commands/workflows, v3/@claude-flow/agents, verification, plugins)
