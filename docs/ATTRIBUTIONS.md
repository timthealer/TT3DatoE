# ATTRIBUTIONS

Список компонентов, заимствованных и адаптированных из open-source репозитория ECC для TT3Dato.

## Источник и лицензия

- **Источник:** https://github.com/affaan-m/ECC
- **Лицензия:** MIT
- **Политика адаптации:** заимствуются только файлы методологии (Markdown); библиотеки, npm-пакеты и харнесс-код ECC НЕ устанавливаются (Конституция, разделы 2, 4, 10).

## Правила (agents/skills/rules/) — 6 файлов

Адаптированы из `rules/common/` репозитория ECC:

| Файл в TT3Dato | Исходник ECC |
|---|---|
| `agents/skills/rules/agents.md` | `rules/common/agents.md` |
| `agents/skills/rules/code-review.md` | `rules/common/code-review.md` |
| `agents/skills/rules/coding-style.md` | `rules/common/coding-style.md` |
| `agents/skills/rules/development-workflow.md` | `rules/common/development-workflow.md` |
| `agents/skills/rules/git-workflow.md` | `rules/common/git-workflow.md` |
| `agents/skills/rules/hooks.md` | `rules/common/hooks.md` |

## Memory Vault — 2 файла

Адаптированы из skill `unified-memory` (формат `ecc.memory.v1`):

| Файл в TT3Dato | Источник |
|---|---|
| `docs/memory/README.md` | ECC unified-memory (стандарт памяти `ecc.memory.v1`) |
| `docs/memory/templates/memory-entry.md` | ECC unified-memory (шаблон записи) |

## Evidence Trail — политика (без файлов)

Адаптирована из цикла ECC `plan -> test -> implement -> review -> verify -> remember -> improve` и концепции hooks. Файлы-носители (`Logs/README.md`, `Tests/README.md`) удалены при реструктуризации 2026-08-11; политика сохранена: процессные логи gitignored (`*.log`), детерминированные проверки — тесты рядом с кодом.

## Security Checklist — 1 файл

Адаптирован из методологии AgentShield (5 категорий: secrets detection, permission auditing, hook injection analysis, MCP server risk profiling, agent config review):

| Файл в TT3Dato | Источник |
|---|---|
| `docs/audits/Agent_Config_Security_Checklist.md` | ECC AgentShield (методология, локальная defensive-версия) |

## Skills (agents/skills/<name>/SKILL.md) — 12 файлов

Адаптированы из `skills/<name>/SKILL.md` репозитория ECC:

| Файл в TT3Dato | Исходник ECC |
|---|---|
| `agents/skills/tdd-workflow/SKILL.md` | `skills/tdd-workflow/SKILL.md` |
| `agents/skills/deep-research/SKILL.md` | `skills/deep-research/SKILL.md` |
| `agents/skills/security-review/SKILL.md` | `skills/security-review/SKILL.md` |
| `agents/skills/context-budget/SKILL.md` | `skills/context-budget/SKILL.md` |
| `agents/skills/unified-memory/SKILL.md` | `skills/unified-memory/SKILL.md` |
| `agents/skills/search-first/SKILL.md` | `skills/search-first/SKILL.md` |
| `agents/skills/cost-aware-llm-pipeline/SKILL.md` | `skills/cost-aware-llm-pipeline/SKILL.md` |
| `agents/skills/documentation-lookup/SKILL.md` | `skills/documentation-lookup/SKILL.md` |
| `agents/skills/agent-eval/SKILL.md` | `skills/agent-eval/SKILL.md` |
| `agents/skills/market-research/SKILL.md` | `skills/market-research/SKILL.md` |
| `agents/skills/parallel-execution-optimizer/SKILL.md` | `skills/parallel-execution-optimizer/SKILL.md` |
| `agents/skills/agent-harness-construction/SKILL.md` | `skills/agent-harness-construction/SKILL.md` |

## Agents (agents/configs/<Name>/) — 7 агентов

Адаптированы из `agents/<name>.md` репозитория ECC:

| Агент TT3Dato | Исходник ECC | Роль в TT3Dato |
|---|---|---|
| `agents/configs/CodeReviewer/` | `agents/code-reviewer.md` | Critic / критический анализ |
| `agents/configs/Planner/` | `agents/planner.md` | Планирование задач и решений |
| `agents/configs/CodeExplorer/` | `agents/code-explorer.md` | Repository Analyst |
| `agents/configs/DocUpdater/` | `agents/doc-updater.md` | Documentation Manager |
| `agents/configs/ChiefOfStaff/` | `agents/chief-of-staff.md` | Координация агентов |
| `agents/configs/AgentEvaluator/` | `agents/agent-evaluator.md` | Оценка качества агентов |
| `agents/configs/DatabaseReviewer/` | `agents/database-reviewer.md` | Аудит баз данных (досье компаний) |

## ADR (docs/adr/) — 5 файлов

| Файл в TT3Dato | Источник |
|---|---|
| `docs/adr/PLAN-PRD-PATTERN.md` | ECC `docs/PLAN-PRD-PATTERN.md` |
| `docs/adr/0001-four-trust-domains-candidate.md` | Aegis `docs/adr/0001-four-trust-domains.md` |
| `docs/adr/0002-verifiable-memory-candidate.md` | Aegis `docs/adr/0002-verifiable-memory.md` |
| `docs/adr/0003-ecc-cycle.md` | ECC (цикл plan->test->implement->review->verify->remember->improve) |
| `docs/adr/0004-omniroute-integration.md` | OmniRoute (diegosouzapw/OmniRoute, MIT) |

## Workflows — 4 файла

| Файл в TT3Dato | Источник |
|---|---|
| `docs/workflows/README.md` | Концепция workflow (ECC/Ruflo) |
| `docs/workflows/development.md` | Ruflo `.claude/commands/workflows/development.md` + цикл ECC |
| `docs/workflows/research.md` | Ruflo `.claude/commands/workflows/research.md` |
| `docs/workflows/review.md` | ECC `workflows/orch-review.workflow.js` + агент code-reviewer |

## Repositories — 2 файла

| Файл в TT3Dato | Источник |
|---|---|
| `docs/repositories/stack-mappings.json` | ECC `config/project-stack-mappings.json` |
| `docs/repositories/inventory.json` | Ruflo `verification/inventory.json` |

## Apps — 1 файл

| Файл в TT3Dato | Источник |
|---|---|
| `apps/README.md` | Формат коннектора из Aegis `connectors/` + ECC `integrations/aura` |

## Итого

Создано 56 файлов (включая 21 файл семи агентов: `system.md` + `config.yaml` + `state.json`); при реструктуризации 2026-08-11 удалены 2 (`Logs/README.md`, `Tests/README.md`) — текущее число 54:

- 6 правил в `agents/skills/rules/`;
- 12 навыков в `agents/skills/<name>/SKILL.md`;
- 7 агентов (21 файл: `agents/configs/<Name>/system.md`, `config.yaml`, `state.json`);
- 2 файла Memory Vault (`docs/memory/README.md`, `docs/memory/templates/memory-entry.md`);
- Evidence Trail — политика без файлов (см. выше);
- 1 security checklist (`docs/audits/Agent_Config_Security_Checklist.md`);
- 5 файлов ADR (`docs/adr/`: `PLAN-PRD-PATTERN.md` + 4 ADR);
- 4 файла Workflows (`docs/workflows/`);
- 2 файла Repositories (`docs/repositories/`);
- 1 файл Apps (`apps/README.md`).

Проверка: 6 + 12 + 21 + 2 + 0 + 1 + 5 + 4 + 2 + 1 = 54.
