#!/bin/bash

LOG_FILE="access.log"

# Генерируем 300 записей
> "$LOG_FILE"

for i in $(seq 1 300); do
    case $((i % 5)) in
        0) IP="192.168.1.10"; STATUS=200; METHOD="GET"; PATH_URL="/api/users" ;;
        1) IP="10.0.0.5"; STATUS=401; METHOD="POST"; PATH_URL="/api/login" ;;
        2) IP="192.168.1.10"; STATUS=200; METHOD="GET"; PATH_URL="/api/users" ;;
        3) IP="172.16.0.20"; STATUS=500; METHOD="GET"; PATH_URL="/api/data" ;;
        4) IP="192.168.1.10"; STATUS=404; METHOD="GET"; PATH_URL="/api/missing" ;;
    esac

    echo "$IP - - [15/Aug/2026:10:15:32] \"$METHOD $PATH_URL HTTP/1.1\" $STATUS" >> "$LOG_FILE"
done

echo "=== Анализ логов ==="

echo "Общее количество запросов:"
wc -l < "$LOG_FILE"

echo "Топ-3 IP-адреса:"
grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -3

echo "Количество ошибок 4xx:"
awk '$NF ~ /^4[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE"

echo "Количество ошибок 5xx:"
awk '$NF ~ /^5[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE"
