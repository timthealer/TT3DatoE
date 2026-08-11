# tools/github — GitHub REST-доступ

Перенесено из TT3DatoE (мобильного приложения, вынесено в timthealer/TT3datoe).
Готовый модуль для код-агента и сборки автоконтекста: чтение дерева репозитория,
просмотр файлов и поиск по имени без `gh` CLI и без скачивания репозитория.

## Что умеет

| Функция | Описание |
|---|---|
| `fetchRepoTree(cfg)` | Рекурсивное дерево файлов (`git/trees/HEAD?recursive=1`). Исключает `node_modules`, `dist`, `build`, `.git`, бинарные расширения и файлы > 300 КБ. Сортировано по пути. |
| `fetchRepoFile(cfg, path)` | Содержимое файла через raw-приёмник (`application/vnd.github.raw`). |
| `verifyGithubToken(token)` | Проверка PAT на `GET /user`, возвращает логин. |
| `searchRepoFiles(name, cfg)` | Поиск по имени файла (без пути): сначала локальное дерево `/__repo`, затем GitHub API. |
| `fetchLocalRepoTree(base)` / `fetchLocalRepoFile(path, base)` | Локальный доступ к репозиторию через dev-сервер (`/__repo/tree`, `/__repo/file?path=`). |

## Использование

```ts
import { fetchRepoTree, fetchRepoFile, searchRepoFiles } from "./github.ts";

const cfg = { owner: "timthealer", repo: "TT3Dato", token: process.env.GITHUB_TOKEN ?? "" };

const tree = await fetchRepoTree(cfg);      // RepoFile[] { path, size }
const src = await fetchRepoFile(cfg, "README.md");
const hit = await searchRepoFiles("github.ts", cfg);
```

## Правила

- **Лимит просмотра — 300 КБ** (`REPO_VIEW_LIMIT_KB = 300`). Файлы больше не загружаются — они бинарники либо бесполезны для контекста.
- **Бинарные расширения** отфильтрованы в `BINARY_EXT` (png, zip, pdf, exe, so, …).
- **Токен не обязателен** для публичных репозиториев; без него на приватных вернётся 404, а не 401 — это ожидаемое поведение GitHub.
- **Friendly-ошибки**: 401/403 → «проверьте токен и права Contents: Read», 404 → «репозиторий не найден», 429 → «лимит запросов».
- При поиске сначала пробуется локальное дерево (`/__repo`), затем GitHub API — так автоконтекст работает даже офлайн на dev-сервере.

## Отличие от agents/github/SKILL.md

- `agents/github/SKILL.md` — управление GitHub через `gh` CLI (issues, PR, releases, Actions) от имени авторизованного пользователя.
- `tools/github/github.ts` — **программное чтение** дерева и файлов репозитория для инжекции в контекст LLM. Не выполняет запись и не требует `gh`.
