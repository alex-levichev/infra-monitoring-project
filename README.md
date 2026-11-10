# Infrastructure Monitoring Project

## Описание проекта

Учебный проект по основам DevOps и мониторинга инфраструктуры.

В проекте реализованы:
- Проверка доступности API с помощью Bash и curl.
- Генерация и анализ логов.
- Анализ HTTP-трафика через Wireshark.
- Запуск API и Nginx с помощью Docker Compose.
- Автоматическая проверка скриптов через GitHub Actions.
- Примеры команд SSH и SCP.

## Проверка API

Скрипт `check_api.sh` проверяет доступность API по HTTP-статусу.

Пример успешной проверки:

```bash
./check_api.sh https://httpbin.org/status/200
```

Пример проверки с ошибкой:

```bash
./check_api.sh https://httpbin.org/status/404
```

Если сервер возвращает HTTP 200, скрипт завершается с кодом 0.
При другом HTTP-статусе скрипт завершается с кодом 1.

## Анализ логов

Скрипт `analyze_logs.sh` генерирует 300 тестовых записей в файл `access.log` и выполняет анализ логов.

Запуск:

```bash
./analyze_logs.sh
```

Скрипт определяет:
- Количество HTTP-ошибок 4xx.
- Количество HTTP-ошибок 5xx.
- Наиболее часто встречающиеся IP-адреса.

Тестовые данные содержат 120 ошибок 4xx и 60 ошибок 5xx.

Файл `access.log` исключён из Git с помощью `.gitignore`.

## Анализ сетевого трафика (Wireshark)

Для захвата и анализа HTTP-трафика используется Wireshark.

Пример генерации HTTP-запроса:

```bash
curl -v http://httpbin.org/get
```

Для просмотра HTTP-пакетов в Wireshark используется фильтр:

```text
http
```

В ходе анализа были обнаружены:
- HTTP-запрос GET /get.
- HTTP-ответ 200 OK.

Результат захвата сохранён в файле `http_traffic.pcapng`.

## Docker Compose

Проект использует два контейнера:
- `api` — тестовый HTTP-сервис.
- `proxy` — Nginx для перенаправления запросов к API.

Запуск:

```bash
docker compose up -d
```

Проверка контейнеров:

```bash
docker compose ps
```

Проверка API:

```bash
curl http://localhost:80
```

Ожидаемый ответ: `Monitoring Service Active`.

Остановка:

```bash
docker compose down
```

## CI/CD (GitHub Actions)

Для автоматической проверки проекта используется GitHub Actions.

При создании Pull Request в ветку `main` запускается CI-пайплайн.

Он выполняет:
- Проверку синтаксиса `check_api.sh`.
- Проверку синтаксиса `analyze_logs.sh`.
- Проверку доступности API через `check_api.sh`.

Конфигурация находится в `.github/workflows/ci.yml`.

Результаты проверок отображаются во вкладке Actions на GitHub.

## SSH и SCP

SSH позволяет безопасно подключаться к удалённому серверу.

Пример подключения:

```bash
ssh user@server_ip
```

SCP используется для копирования файлов между локальным компьютером и сервером.

Копирование скрипта на сервер:

```bash
scp check_api.sh user@server_ip:~/
```

Копирование файла с сервера:

```bash
scp user@server_ip:~/access.log ./
```

В примерах `user` — имя пользователя на сервере,
а `server_ip` — IP-адрес сервера.

