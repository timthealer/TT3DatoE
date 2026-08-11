# Автоподключение бесплатных провайдеров (OAuth)

OmniRoute умеет **сам подключать бесплатные провайдеры** через OAuth — без API-ключей, только через ваш браузер. Это встроенная функция, отдельный инструмент (Maxun) для базового автоподключения не требуется.

## Доступные провайдеры

```
$ omniroute oauth providers

| Provider ID  | Name               | Flow    |
|--------------|--------------------|---------|
| gemini       | Google Gemini      | browser |
| antigravity  | Antigravity        | browser |
| windsurf     | Windsurf           | browser |
| qwen         | Qwen Code          | browser |
| cursor       | Cursor             | import  |
| zed          | Zed                | import  |
| kiro         | Amazon Kiro        | social  |
| claude-code  | Claude Code (OAuth)| device  |
| codex        | OpenAI Codex (OAuth)| device |
| copilot      | GitHub Copilot     | device  |
```

## Как подключить бесплатный провайдер

### Browser-флоу (gemini, antigravity, windsurf, qwen)

```bash
omniroute oauth start --provider gemini --no-browser
# CLI печатает URL → открываете в браузере → логинитесь → разрешаете доступ
# CLI сам дождётся колбэка и сохранит подключение
```

### Device-флоу (codex, copilot, claude-code) — без браузера на сервере

```bash
omniroute oauth start --provider copilot
# Печатает код → вводите его на github.com/login/device → токен сохраняется
```

### Import-флоу (cursor, zed) — из локального конфига

```bash
omniroute oauth start --provider cursor --import-from-system
```

## Статус и проверка

```bash
omniroute oauth status        # активные подключения (нужна сессия дашборда)
omniroute providers list      # что активно сейчас
omniroute providers test-all  # проверить все подключения
```

## Что уже подключено

`antigravity` (аккаунт timthealer@gmail.com) — работает и даёт бесплатные алиасы `auto/cheap`, `auto/coding:free`, `oc/deepseek-v4-flash-free`.

## Зачем тогда Maxun

Maxun (или аналог) нужен **только** для автоматизации OAuth-флоу в массовом порядке (когда провайдеров десятки и логиниться вручную нереально). Для MVP с несколькими бесплатными провайдерами достаточно встроенного `omniroute oauth start`.

## Правила безопасности

- Подключайте провайдеров через официальный OAuth-флоу (бrowser/device). Не используйте сторонние скрипты, собирающие ключи.
- Каждый провайдер привязывается к вашему аккаунту (GitHub/Google) — подключайте только свои аккаунты.
- Никакие ключи и токены не коммитить в репозиторий.
