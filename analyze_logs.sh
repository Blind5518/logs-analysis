
#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="access.log"
REPORT="report.txt"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Файл $LOG_FILE не найден!"
  exit 1
fi

total_requests=$(wc -l < "$LOG_FILE")
unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort -u | wc -l)
methods=$(
  awk '{gsub(/"/,""); print $6}' "$LOG_FILE" |
  awk '{cnt[$1]++} END{for (k in cnt) printf "%d %s\n", cnt[k], k}' |
  sort -nr
)
popular_url=$(awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

{
  echo "Отчет о логах веб-сервера"
  echo "========================="
  echo
  echo "Общее количество запросов: $total_requests"
  echo "Количество уникальных IP-адресов: $unique_ips"
  echo
  echo "Количество запросов по методам:"
  echo "$methods"
  echo
  echo "Самый популярный URL: $popular_url"
} > "$REPORT"

echo "Отчет сохранен в файл $REPORT"

