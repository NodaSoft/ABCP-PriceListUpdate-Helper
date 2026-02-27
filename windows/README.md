Использование
=============

Вариант 1: VBS (старый, использует `curl`)
------------------------------------------

В файле **upload.vbs** необходимо указать параметры доступа к API вашего сайта в блоке *Settings* в самом начале файла

	' Settings '
	Dim ApiUserLogin, ApiUserPsw, ApiHost
	ApiUserLogin = ""
	ApiUserPsw = ""
	ApiHost = ""
	' End Settings '

Запуск:

	start.bat <distributor_id> <path_to_price_file> [inc]

`inc` - необязательный параметр для инкрементальной загрузки (`fileTypeId=4`).

Вариант 2: PowerShell (новый, без `curl`)
-----------------------------------------

Требуется Windows PowerShell 5.1+ или PowerShell 7+.

Перед запуском задайте переменные окружения:

	set API_USERNAME=...
	set API_USERPSW=...
	set API_HOST=api.abcp.ru

Запуск:

	start_powershell.bat <distributor_id> <path_to_price_file> [inc]

Или напрямую:

	powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\upload.ps1 -DistributorId <distributor_id> -FilePath <path_to_price_file> -Mode inc
