# llm-router/auto-combo — авто-комбо и fallback-каскад

Паттерны автоматического подбора модели под задачу и отказоустойчивого каскада,
перенесённые из TT3DatoE (src/api.ts) и адаптированные под роутер OmniRoute.

## Содержимое

| Файл | Назначение |
|---|---|
| `combo.ts` | Схемы комбо-цепочек OmniRoute (стратегии, таймауты, response-validation). |
| `freeModels.ts` | Детекция бесплатных моделей по каталогу `FREE_MODEL_BUDGETS`. |
| `routingStrategies.ts` | Список стратегий маршрутизации (priority, weighted, round-robin, …). |

## Паттерн: каскад кандидатов (fallback)

Идея из TT3DatoE: не одна модель, а **упорядоченный список кандидатов**; при
ошибке (HTTP ≠ 200, пустой ответ, таймаут) запрос переходит к следующему.

### 1. Определение задачи (`detectTask`)

По последнему user-сообщению (по убыванию приоритета):

| Режим | Сигналы |
|---|---|
| `coding` | блоки кода ` ``` `, ключевые слова function/import/class, слова «код, ошибка, баг, отлад, api, компонент». |
| `reasoning` | «почему, объясни, проанализируй, план, спроектируй, стратегия, архитектура, исследуй». |
| `fast` | «кратко, коротко, срочно, одним словом, да или нет». |
| `chat` | «привет, как дела, расскажи, помоги». |
| `auto` | не найдено → default `coding`. |

### 2. Сбор кандидатов (`buildCandidates`)

- Пул = включённые провайдеры (или один «закреплённый»).
- Каждая модель провайдера участвует, если её `tasks` включают текущий режим.
- Сортировка по `quality` (убывание).
- **Свой роутер (OmniRoute) с алиасом `auto*`** добавляется с цепочкой запасных
  алиасов — для надёжности:

  ```
  auto               → ["auto/best-chat", "auto/best-coding"]
  auto/best-chat     → ["auto/best-coding", "auto"]
  auto/best-coding   → ["auto/best-chat", "auto"]
  ```

### 3. Выполнение с авто-fallback (`chatCompletion`)

```
for candidate in candidates:
    try:
        res = POST {candidate.base}/chat/completions
        if !res.ok: continue                    # HTTP-ошибка → следующий
        if !stream:
            content = res.json().choices[0].message.content
            if typeof content !== string: continue   # пустой ответ → следующий
            return { content, provider, model }
        text = readStream(res)                  # streaming (SSE, `data:`-фрагменты)
        if !text: continue                      # «Роутер вернул пустой ответ»
        return { text, provider, model }
    except AbortError: rethrow                  # отмену пользователя не глотаем
    except e: lastError = e                     # сеть/JSON → следующий
throw lastError
```

### Ключевые правила

- **Пустой ответ — тоже ошибка.** В streaming: если провайдер прислал только
  `[DONE]` без контента, переходим дальше. Некоторые провайдеры OmniRoute под
  алиасом `auto*` периодически «молчат» — это главная причина каскада.
- **AbortError пробрасывается** — отмену пользователя нельзя заменять фолбэком.
- Friendly-ошибки для пользователя: AbortError → «Отправка прервана», Failed to
  fetch → «проверьте адрес, интернет и CORS», 401/403 → «проверьте API-ключ».

## Отличие от нативного OmniRoute

OmniRoute сам умеет каскад через комбо (стратегии + `maxRetries` + target failover).
Данный паттерн — **клиентский слой**: полезен для мобильного/десктопного клиента,
который ходит в роутер по `/v1` и хочет пережить «молчащие» алиасы без вмешательства
в конфиг сервера.
