# TT3Dato Handoff

## Статус проекта

- Фаза 2: Кроссплатформенное приложение
- Чат 1/3: Фундамент монорепозитория — ЗАВЕРШЁН
- Чат 2/3: Модуль синхронизации — ОЖИДАЕТ
- Чат 3/3: Приложение + CI/CD — ОЖИДАЕТ

## Что сделано в Чате 1

- Настроен pnpm workspaces (корневой `package.json` + `pnpm-workspace.yaml`, lockfile)
- Создан `tsconfig.base.json` (strict, ES2022, Bundler resolution)
- Настроен ESLint + Prettier + Husky (pre-commit через lint-staged)
- Создан `vitest.config.ts` с покрытием (`@vitest/coverage-v8`)
- Созданы заглушки для всех пакетов (`packages/*`, `apps/*`) с `src/index.ts`
- Обновлены `.gitignore`, `.editorconfig`, `README.md`

## Что нужно сделать в Чате 2

- Реализовать `packages/sync/` (git-sync, conflict-resolver, offline-store, p2p-sync)
- Написать тесты для `packages/sync/`
- Интегрировать существующий код Phase 1 в workspace-пакеты (см. decisions)

## Что нужно сделать в Чате 3

- Создать `apps/mobile/` и `apps/desktop/` (Tauri)
- Создать `packages/ui/` и `packages/app-core/`
- Настроить CI/CD (GitHub Actions)
- Обновить документацию

## Архитектурные решения

См. docs/decisions.md
