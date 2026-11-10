#!/bin/bash

URL="$1"

if [ -z "$URL" ]; then
    echo "Ошибка: укажите URL"
    exit 1
fi

HTTP_CODE=$(curl -L -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" = "200" ]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $HTTP_CODE"
    exit 1
fi
