# ABCP Price List Update Helper

Кроссплатформенные утилиты для загрузки прайс-листов в API ABCP:
`/cp/distributor/pricelistUpdate`.

## Структура проекта

- `python/update_price.py`: основной современный CLI-скрипт
- `posix/update_price.sh`: helper-скрипт для *nix/POSIX-систем
- `windows/upload.ps1` + `windows/start_powershell.bat`: загрузка через Windows PowerShell (без `curl`)
- `windows/upload.vbs` + `windows/start.bat`: устаревший вариант для Windows (использует `curl`)

## Доступ к API

Для всех вариантов нужны одинаковые параметры:

- `API_USERNAME`: логин API
- `API_USERPSW`: пароль API
- `API_HOST`: хост API или полный URL, например:
  - `api.abcp.ru`
  - `https://api.abcp.ru`

## Необходимое ПО

### Python CLI (`python/update_price.py`)

- Python 3.10+
- пакет `requests`

Установка:

```bash
python3 -m pip install requests
```

### POSIX-скрипт (`posix/update_price.sh`)

- Bash 4+
- `curl`

Проверка:

```bash
bash --version
curl --version
```

### Windows PowerShell (рекомендуется)

- Windows PowerShell 5.1+ или PowerShell 7+

### Windows VBS (устаревший вариант)

- Windows Script Host (`cscript.exe`)
- `curl` в `PATH` (или `windows/curl.exe` в той же папке)

## Использование

### 1) Python CLI (рекомендуется)

```bash
export API_USERNAME="..."
export API_USERPSW="..."
export API_HOST="api.abcp.ru"

python3 python/update_price.py <distributor_id> <path_to_price_list>
python3 python/update_price.py <distributor_id> <path_to_price_list> --incremental
```

Опционально:

```bash
python3 python/update_price.py <distributor_id> <path_to_price_list> --timeout 120
```

### 2) POSIX Shell

```bash
export API_USERNAME="..."
export API_USERPSW="..."
export API_HOST="api.abcp.ru"

./posix/update_price.sh <distributor_id> <path_to_price_list>
./posix/update_price.sh <distributor_id> <path_to_price_list> inc
```

### 3) Windows PowerShell (без `curl`)

`cmd.exe`:

```bat
set API_USERNAME=...
set API_USERPSW=...
set API_HOST=api.abcp.ru
windows\start_powershell.bat <distributor_id> <path_to_price_file> [inc]
```

Напрямую из PowerShell:

```powershell
$env:API_USERNAME="..."
$env:API_USERPSW="..."
$env:API_HOST="api.abcp.ru"
.\windows\upload.ps1 -DistributorId <distributor_id> -FilePath <path_to_price_file> -Mode inc
```

### 4) Windows VBS (устаревший, с `curl`)

Укажите параметры доступа в начале `windows/upload.vbs`, затем запустите:

```bat
windows\start.bat <distributor_id> <path_to_price_file> [inc]
```

## Примечания

- `inc` / `--incremental` отправляет `fileTypeId=4`.
- Полная загрузка отправляет `fileTypeId=1`.
- Если `API_HOST` задан без протокола, используется `https://`.
