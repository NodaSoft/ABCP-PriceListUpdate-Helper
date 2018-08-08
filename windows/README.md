Использование
=============

В файле **start.bat** необходимо в строке

	cscript.exe upload.vbs 000000 .\price.csv
заменить число **000000** на идентификатор вашего склада.

В файле **upload.vbs** необходимо указать параметры доступа к API вашего сайта в блоке *Settings* в самом начале файла

	' Settings '
	Dim ApiUserLogin, ApiUserPsw, ApiHost
	ApiUserLogin = ""
	ApiUserPsw = ""
	ApiHost = ""
	' End Settings '

Положить файл с прайс-листом (price.csv) в папку с .bat-файлом и запустить последний. 
