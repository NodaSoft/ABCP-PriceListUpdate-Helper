Использование
=============

В файле **update_price.sh** в блоке *Config* в самом начале файла необходимо указать параметры доступа к API вашего сайта.

	# Config
	API_USERNAME=""
	API_USERPSW=""
	API_HOST=""
	#


Скрипт принимает три аргумента:

Идентификатор склада

Путь к прайс-листу

Флаг инкрементного прайса (необязательный)




	sh ./update_price.sh 000000 /tmp/pricelist.csv


или

	
	sh ./update_price.sh 000000 /tmp/pricelist.csv inc

