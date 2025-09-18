#!/bin/bash

LOGFILE="system_health.log"

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=500

# CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*}  # integer
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "ALERT: High CPU Usage: ${CPU_USAGE}%" | tee -a "$LOGFILE"
fi

# Memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
MEMORY_USAGE=${MEMORY_USAGE%.*}
if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    echo "ALERT: High Memory Usage: ${MEMORY_USAGE}%" | tee -a "$LOGFILE"
fi

# Disk usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: High Disk Usage: ${DISK_USAGE}%" | tee -a "$LOGFILE"
fi

# Process count
PROCESS_COUNT=$(ps -e --no-headers | wc -l)
if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    echo "ALERT: Too many running processes: $PROCESS_COUNT" | tee -a "$LOGFILE"
fi

# If no alerts
if [ "$CPU_USAGE" -le "$CPU_THRESHOLD" ] && [ "$MEMORY_USAGE" -le "$MEMORY_THRESHOLD" ] && [ "$DISK_USAGE" -le "$DISK_THRESHOLD" ] && [ "$PROCESS_COUNT" -le "$PROCESS_THRESHOLD" ]; then
    echo "System is healthy ✅" | tee -a "$LOGFILE"
fi
echo "----------------------------------------" >> "$LOGFILE"
# End of script