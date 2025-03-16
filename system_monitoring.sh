#!/bin/bash

LOG_FILE="/var/log/system_monitor.log"
THRESHOLD_CPU=80
THRESHOLD_RAM=80
THRESHOLD_DISK=90

echo_log() {
    echo "[$(date)] $1" | tee -a "$LOG_FILE"
}

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
if (( $(echo "$CPU_USAGE > $THRESHOLD_CPU" | bc -l) )); then
    echo_log "WARNING: High CPU usage detected - $CPU_USAGE%"
fi

# Check RAM usage
RAM_USAGE=$(free | awk '/Mem/ {printf("%.2f"), $3/$2 * 100}')
if (( $(echo "$RAM_USAGE > $THRESHOLD_RAM" | bc -l) )); then
    echo_log "WARNING: High RAM usage detected - $RAM_USAGE%"
fi

# Check Disk usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -ge "$THRESHOLD_DISK" ]; then
    echo_log "WARNING: High Disk usage detected - $DISK_USAGE%"
fi

# Check Network usage
RX_BYTES=$(cat /sys/class/net/eth0/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/eth0/statistics/tx_bytes)
sleep 1
RX_BYTES_NEW=$(cat /sys/class/net/eth0/statistics/rx_bytes)
TX_BYTES_NEW=$(cat /sys/class/net/eth0/statistics/tx_bytes)

RX_RATE=$(( (RX_BYTES_NEW - RX_BYTES) / 1024 ))
TX_RATE=$(( (TX_BYTES_NEW - TX_BYTES) / 1024 ))

echo_log "Network usage - Download: ${RX_RATE} KB/s, Upload: ${TX_RATE} KB/s"

echo_log "System health check completed."

exit 0