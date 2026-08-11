> Источник: перенос кода из timthealer/TT3datoe (мобильное приложение TT3DatoE) в TT3Dato. Адаптировано для TT3Dato.

# Шаблон записи памяти (ecc.memory.v1)

---

- id: MEM-0004
- date: 2026-08-09
- scope: project
- source: репо timthealer/TT3datoe, main 51f1e3e
- status: verified
- tags: [tt3datoe, перенос, github, автоконтекст, fallback, файлы-вкладка]

---

# Перенос ценного из TT3DatoE в TT3Dato

TT3DatoE (мобильное приложение) вынесено в отдельный репозиторий `timthealer/TT3datoe`; ценное перенесено в структуру TT3Dato как паттерны и готовые модули.

## Контекст

TT3Dato — база знаний/паттернов с реальным кодом инструментов (не запускаемое приложение). Ценное из TT3DatoE перенесено, чтобы код-агент и роутер могли переиспользовать проверенные паттерны.

## Подтверждение

Перенесённые артефакты (все на месте, читаются):

- `packages/tools/github/github.ts` — GitHub REST-доступ: `fetchRepoTree`, `fetchRepoFile`, `verifyGithubToken`, `searchRepoFiles`, `fetchLocalRepoTree/File` (`/__repo`). Лимит просмотра 300 КБ, фильтр бинарных расширений, friendly-ошибки (401/403 → «проверьте токен и Contents: Read», 404 → «репозиторий не найден», 429 → «лимит»). `packages/tools/github/README.md` описывает отличие от `agents/skills/github/SKILL.md` (gh CLI vs REST-чтение).
- `packages/core/memory/src/repo-context.ts` — автоконтекст из репозитория: `buildRepoContext` + `extractFileNames` + `FILE_RE` (максимум 5 файлов, `MAX_FILE_CHARS = 12000`, сначала локальное дерево `/__repo`, затем GitHub API). Импорт: `../../../tools/github/github.ts`.
- `packages/llm-router/auto-combo/README.md` — паттерн fallback-каскада из `api.ts`: `detectTask` (coding/reasoning/fast/chat), `buildCandidates` (сортировка по quality, алиас `auto*` → цепочка запасных `auto/best-chat` ↔ `auto/best-coding`), `chatCompletion` (пустой ответ = ошибка → следующий кандидат; AbortError пробрасывается).
- `docs/files-tab-and-pending-context.md` — файлы-вкладка + отложенный контекст: `savePendingContext` (TTL 10 минут, ключ `tt3datoe.pendingContext.v1`), приём на маунте ChatScreen, разделение источников local/github, обёртка `[Файл из репозитория: <path>]`.

Обновлены ссылки: `packages/llm-router/README.md` — упоминание TT3DatoE заменено на `auto-combo/README.md` (клиентский fallback-каскад). В корневом `README.md` упоминаний TT3datoe нет.

## Последствия

- Код-агент может читать дерево/файлы репозитория через `packages/tools/github/github.ts` без `gh` CLI и без скачивания.
- Автоконтекст (`buildRepoContext`) встраивает упомянутые в промпте файлы — использовать в код-агенте для экономии токенов (макс. 5 файлов, обрезка 12 КБ).
- Fallback-каскад из TT3DatoE — клиентский слой поверх роутера: переживает «молчащие» алиасы `auto*` (пустой ответ → следующий кандидат). Не конфликтует с нативным каскадом OmniRoute (комбо).
- Исходники TT3DatoE остаются в `/tmp/opencode/TT3datoe/TT3DatoE/` (github.ts, api.ts, storage.ts, ChatScreen.tsx, FilesScreen.tsx) до завершения переноса.

## Продвижение

