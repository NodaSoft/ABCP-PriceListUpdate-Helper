# ABCP Price List Update Helper

Утилита для загрузки прайс-листов через API ABCP `cp/distributor/pricelistUpdate`.

## Установка

1. Установите Python 3.10+.
2. Установите зависимости:

```bash
python3 -m pip install requests
```

## Использование

Перед запуском задайте переменные окружения:
- `API_USERNAME`: логин API
- `API_USERPSW`: пароль API
- `API_HOST`: хост или полный URL, например `api.abcp.ru` или `https://api.abcp.ru`

Полная загрузка:

```bash
python3 update_price.py <distributor_id> <path_to_price_list>
```

Инкрементальная загрузка (`fileTypeId=4`):

```bash
python3 update_price.py <distributor_id> <path_to_price_list> --incremental
```

- `--timeout <seconds>`: переопределить HTTP timeout (по умолчанию `60`).

## Опции

- `--incremental`: отправить инкрементальное обновление (`fileTypeId=4`)
- `--timeout`: таймаут HTTP-запроса в секундах

## POSIX-скрипт

`posix/update_price.sh` использует те же переменные окружения и принимает:

```bash
./posix/update_price.sh <distributor_id> <path_to_price_list> [inc]
```
