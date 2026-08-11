# Development Workflow

> Источник методологии: https://github.com/ruvnet/ruflo (MIT, `.claude/commands/workflows/development.md`) + https://github.com/affaan-m/ECC (MIT). Адаптировано для TT3Dato.

Реализует цикл Конституции (раздел 15): plan -> test -> implement -> review -> verify -> remember -> improve.

## Шаги

### 1. Plan (агент Planner)

- Получить или создать PRD (`docs/prds/{name}.prd.md`) по шаблону `docs/adr/PLAN-PRD-PATTERN.md`;
- Создать план (`docs/plans/{name}.plan.md`): файлы, паттерны, задачи, команды валидации.

Артефакт: `docs/plans/*.plan.md`

### 2. Test (agents/skills/tdd-workflow)

- Написать падающий тест (RED) до реализации;
- Зафиксировать свидетельство RED (тест рядом с кодом, `packages/`).

Артефакт: падающий тест (RED) + evidence.

### 3. Implement

- Реализовать минимальный diff до прохождения теста (GREEN);
- Зафиксировать свидетельство GREEN.

### 4. Review (агент CodeReviewer)

- Свежий контекст, не автор;
- Находки только с уверенностью выше 80%, с доказательствами;
- Вердикт Approve / Warning / Block (Workflow `review.md`).

### 5. Verify

- Прогнать build, lint, typecheck, тесты (детерминированные проверки, тесты рядом с кодом);
- Подтвердить корректность.

### 6. Remember

- Сохранить решение и опыт в `docs/memory/` (формат `ecc.memory.v1`, статус unverified);
- Верифицированные знания продвигаются в документы (ADR-0002).

### 7. Improve

- На основе опыта улучшить workflow/навыки;
- Обновить инвентарь (`docs/repositories/inventory.json`).

## Связь с агентами

| Шаг | Агент | Выход |
|---|---|---|
| plan | Planner | `docs/plans/*.plan.md` |
| test/implement | tdd-workflow | код + тесты |
| review | CodeReviewer | вердикт |
| remember | Memory Vault | `docs/memory/*` |
