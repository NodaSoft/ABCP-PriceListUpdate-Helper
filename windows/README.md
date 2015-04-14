Использование
=============

В файлах **start_full.bat** (загрузка полного прайс-листа) и **start_inc.bat** (загрузка инкрементного прайс-листа) необходимо в строке

	cscript.exe upload.vbs 000000 .\price.csv
заменить число **000000** на идентификатор вашего склада.

В файле **upload.vbs** необходимо указать параметры доступа к API вашего сайта в блоке *Settings* в самом начале файла

	' Settings '
	Dim ApiUserLogin, ApiUserPsw, ApiHost
	ApiUserLogin = ""
	ApiUserPsw = ""
	ApiHost = ""
	' End Settings '

Положить файл с прайс-листом (price.csv) в папку с .bat-файлами и запустить нужный. 
