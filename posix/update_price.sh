#!/bin/bash

# Config
API_USERNAME=""
API_USERPSW=""
API_HOST=""
#
FILE_TYPE_ID="1"
INCREMENT_STRING=""

if [ "${3}" = "inc" ]
then
	FILE_TYPE_ID="4"
	INCREMENT_STRING=" инкрементного"
fi

echo "Начало загрузки$INCREMENT_STRING прайса...\n";

RESULT=$(curl -X POST -H "Content-Type: multipart/form-data" -F "userlogin=$API_USERNAME" -F "userpsw=$API_USERPSW" -F "distributorId=${1}" -F "fileTypeId=$FILE_TYPE_ID" -F "uploadFile=@${2}" http://$API_HOST/cp/distributor/pricelistUpdate)
MESSAGE_ERROR=$(echo "$RESULT" | sed -e 's/^.*\"errorMessage\"[ ]*:[ ]*\"//' -e 's/\".*//')
if [ "$MESSAGE_ERROR" != "{" ]
then
	/usr/bin/printf "Ошибка: $MESSAGE_ERROR\n"
else
	/usr/bin/printf "$(echo \"$RESULT\" | sed -e 's/^.*\"message\"[ ]*:[ ]*\"//' -e 's/\".*//')\n"
fi
