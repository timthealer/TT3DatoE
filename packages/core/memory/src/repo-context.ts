/**
 * Автоконтекст из репозитория: из текста пользователя извлекаются имена файлов
 * (foo.ts, README.md …), файлы находятся в репозитории и их содержимое
 * встраивается в промпт перед отправкой в LLM.
 *
 * Перенесено из TT3DatoE (src/screens/ChatScreen.tsx, buildAutoContext) как
 * паттерн сборки контекста для код-агента.
 *
 * Последовательность для каждого файла:
 *   1. локальное дерево `/__repo` (текущий репозиторий на сервере),
 *   2. GitHub API с токеном (остальные репозитории),
 *   3. недоступные файлы тихо пропускаются.
 */
import { fetchRepoFile, searchRepoFiles } from "../../../tools/github/github.ts";
import type { RepoConfig } from "../../../tools/github/github.ts";

/** Имена файлов в тексте: `src/main.ts`, `Dockerfile`-подобные с расширением. */
export const FILE_RE =
  /\b[\w.-]+\.(ts|tsx|js|jsx|md|json|css|html|py|go|rs|java|sh|yaml|yml|sql|xml|env)\b/g;

/** Максимум файлов, встраиваемых в контекст за один ход. */
export const MAX_CTX_FILES = 5;

/** Обрезка содержимого файла перед встраиванием (символов). */
export const MAX_FILE_CHARS = 12000;

/** Сколько совпадений пути брать на одно имя файла (полный путь уникальнее). */
const MAX_HITS_PER_NAME = 3;

export interface RepoContextOptions {
  cfg?: RepoConfig;
  localBase?: string;
  maxFiles?: number;
}

/** Извлекает имена файлов из текста (без повторов). */
export function extractFileNames(text: string): string[] {
  const names = new Set<string>();
  for (const m of text.matchAll(FILE_RE)) names.add(m[0]);
  return [...names];
}

/**
 * Встраивает содержимое упомянутых файлов в контекст. Возвращает блок вида
 * `Контекст из репозитория:\n--- path ---\n<content>`, или "" если файлов нет.
 */
export async function buildRepoContext(
  text: string,
  enabled: boolean,
  opts: RepoContextOptions = {},
): Promise<string> {
  if (!enabled || !text) return "";
  const names = extractFileNames(text);
  if (names.length === 0) return "";
  const { cfg, localBase = "/__repo", maxFiles = MAX_CTX_FILES } = opts;
  const parts: string[] = [];
  for (const name of names.slice(0, maxFiles)) {
    try {
      const hits = await searchRepoFiles(name, cfg?.owner && cfg.repo ? cfg : undefined, localBase);
      for (const f of hits.slice(0, MAX_HITS_PER_NAME)) {
        try {
          // сначала пробуем локальное дерево (текущий репозиторий на сервере),
          // затем — GitHub API с вшитым токеном (остальные репозитории)
          let content = "";
          const local = await fetch(`/__repo/file?path=${encodeURIComponent(f.path)}`);
          if (local.ok) {
            content = await local.text();
          } else if (cfg?.owner && cfg.repo) {
            content = await fetchRepoFile(cfg, f.path);
          }
          if (!content) continue;
          parts.push(`--- ${f.path} ---\n${content.slice(0, MAX_FILE_CHARS)}`);
        } catch {
          // файл недоступен — пропускаем
        }
      }
    } catch {
      // поиск не удался — пропускаем
    }
  }
  return parts.length > 0 ? `\n\nКонтекст из репозитория:\n${parts.join("\n\n")}` : "";
}
