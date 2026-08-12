# Архитектурные решения TT3Dato (Фаза 2)

> Лог решений, принятых в Чате 1/3 (фундамент монорепозитория). Формат: ADR-lite — контекст, решение, последствия.

## ADR-2026-001: pnpm workspaces как основа монорепозитория

**Контекст:** нужен единый репозиторий для 7+ пакетов и 2 приложений с общей сборкой, тестами и линтингом.

**Решение:** корневой `package.json` + `pnpm-workspace.yaml` (`packages/*`, `apps/*`), `pnpm -r build`, единый `tsconfig.base.json`, ESLint, Prettier, Husky pre-commit (lint-staged), Vitest.

**Последствия:** pnpm-lock.yaml зафиксирован; пакеты могут ссылаться друг на друга через workspaces без публикации в npm.

## ADR-2026-002: Заглушки пакетов через `src/`, существующий код Phase 1 не трогаем

**Контекст:** в `packages/core`, `packages/tools`, `packages/llm-router`, `packages/traces` уже лежит рабочий код Phase 1 (memory, swarm, federation, trust-domains, auto-combo, rotation и т.д.) без собственных `package.json`/`tsconfig.json`. Он использует внешние зависимости (pdfjs-dist, exceljs, mammoth, chokidar и др.), которых нет в lockfile.

**Решение:** каждый пакет получает минимальный `package.json` + `tsconfig.json` + `src/index.ts` заглушку. Существующий код Phase 1 НЕ переносится и НЕ правится в Чате 1. Vitest и ESLint исключают legacy-пути (см. `vitest.config.ts`, `.eslintrc.cjs`).

**Последствия:** `pnpm build`/`pnpm test`/`pnpm lint` зелёные уже сейчас. Интеграция кода Phase 1 в workspace-пакеты (перенос в `src/`, добавление зависимостей, включение в тесты) — отдельная задача для Чата 2/3.

## ADR-2026-003: Vitest включён только для новых `src/`-структур

**Контекст:** старые тесты Phase 1 (`packages/tools/**/*.test.ts` и т.п.) требуют внешних зависимостей и падают без них.

**Решение:** `vitest.config.ts` использует `include: ['packages/*/src/**/*.test.ts', 'apps/*/src/**/*.test.ts']`.

**Последствия:** тесты нового кода запускаются; legacy-тесты вернутся после интеграции Phase 1 (ADR-2026-002).

## ADR-2026-004: ESLint 8 (eslintrc) вместо ESLint 9

**Контекст:** задание требует `.eslintrc.js`. ESLint 9 не поддерживает eslintrc без flat-config, а typescript-eslint 8 совместим с ESLint 8.57+.

**Решение:** зафиксирован `eslint@^8.57.0` с `.eslintrc.cjs`, плагины `@typescript-eslint`.

**Последствия:** конфиг соответствует заданию; при желании мигрировать на flat-config — отдельная задача.

## ADR-2026-005: pnpm 11 — политика build-скриптов через `allowBuilds`

**Контекст:** pnpm 10+ блокирует postinstall-скрипты зависимостей (esbuild нужен Vitest).

**Решение:** в `pnpm-workspace.yaml` добавлен `allowBuilds: { esbuild: true, '@esbuild/linux-x64': true }`.

**Последствия:** esbuild собирается корректно, Vitest работает; новые зависимости с build-скриптами потребуют явного одобрения.
