#!/bin/bash

LOGFILE="app_health.log"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL=$1

STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}" "$URL")

if [ "$STATUS_CODE" -eq 200 ]; then
    echo "✅ Application is UP at $URL" | tee -a "$LOGFILE"
else
    echo "❌ Application is DOWN at $URL (Status Code: $STATUS_CODE)" | tee -a "$LOGFILE"
fi
echo "----------------------------------------" >> "$LOGFILE"
# End of script 
