#!/bin/bash

#--- Configuration ---
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
LOAD_THRESHOLD=10.0
NETWORK_INTERFACE="eth0" 

#--- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' 

#--- Data Collection ---
export LC_ALL=C
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# System Info
HOSTNAME=$(hostname)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
LOGGED_IN_USERS=$(who | wc -l)

# Resource Usage
CPU_USAGE=$(top -b -n 1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
MEM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
MEM_USED=$(free -m | grep Mem | awk '{print $3}')
MEM_USAGE=$((MEM_USED * 100 / MEM_TOTAL))
DISK_USAGE=$(df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//')
LOAD_AVERAGE=$(uptime | awk -F'load average: ' '{print $2}')

# Network Usage (KB/s)
RX_BEFORE=$(cat /sys/class/net/$NETWORK_INTERFACE/statistics/rx_bytes)
TX_BEFORE=$(cat /sys/class/net/$NETWORK_INTERFACE/statistics/tx_bytes)
sleep 1
RX_AFTER=$(cat /sys/class/net/$NETWORK_INTERFACE/statistics/rx_bytes)
TX_AFTER=$(cat /sys/class/net/$NETWORK_INTERFACE/statistics/tx_bytes)
RX_SPEED=$(echo "scale=2; ($RX_AFTER - $RX_BEFORE) / 1024" | bc)
TX_SPEED=$(echo "scale=2; ($TX_AFTER - $TX_BEFORE) / 1024" | bc)

# Top Processes & Connections
TOP_CPU_PROCESSES=$(ps aux --sort=-%cpu | head -n 6)
TOP_MEM_PROCESSES=$(ps aux --sort=-%mem | head -n 6)
ACTIVE_CONNECTIONS=$(ss -tuanp | grep 'ESTAB' | head -n 5)


#--- Reporting ---
echo -e "${CYAN}--- System Resource Report for '$HOSTNAME' ($TIMESTAMP) ---${NC}"

printf "%-18s : %s\n" "Kernel Version" "$KERNEL"
printf "%-18s : %s\n" "System Uptime" "$UPTIME"
printf "%-18s : %s\n" "Logged-in Users" "$LOGGED_IN_USERS"
echo ""

printf "%-18s : %s%%\n" "CPU Usage" "$CPU_USAGE"
printf "%-18s : %s%% (%s/%s MB)\n" "RAM Usage" "$MEM_USAGE" "$MEM_USED" "$MEM_TOTAL"
printf "%-18s : %s%%\n" "Disk Usage (/)" "$DISK_USAGE"
printf "%-18s : %s\n" "Load Average" "$LOAD_AVERAGE"
printf "%-18s : %s KB/s RX | %s KB/s TX\n" "Network ($NETWORK_INTERFACE)" "$RX_SPEED" "$TX_SPEED"
echo ""

echo -e "${CYAN}--- System Status ---${NC}"
HAS_ALERT=false
compare_float() { echo "$1 >= $2" | bc -l; }

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
  echo -e "${YELLOW}(!) WARNING: CPU usage is at ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)${NC}"
  HAS_ALERT=true
fi
if [ "$MEM_USAGE" -ge "$MEM_THRESHOLD" ]; then
  echo -e "${YELLOW}(!) WARNING: RAM usage is at ${MEM_USAGE}% (Threshold: ${MEM_THRESHOLD}%)${NC}"
  HAS_ALERT=true
fi
if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
  echo -e "${YELLOW}(!) WARNING: Disk usage is at ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)${NC}"
  HAS_ALERT=true
fi
if (( $(compare_float $(echo $LOAD_AVERAGE | cut -d, -f1) $LOAD_THRESHOLD) )); then
  echo -e "${YELLOW}(!) WARNING: 1m Load Average is at $(echo $LOAD_AVERAGE | cut -d, -f1) (Threshold: ${LOAD_THRESHOLD})${NC}"
  HAS_ALERT=true
fi

if [ "$HAS_ALERT" = false ]; then
  echo -e "${GREEN} OK: All parameters are within normal thresholds.${NC}"
fi
echo ""

echo -e "${CYAN}--- Top 5 Processes (by CPU) ---${NC}"
echo "$TOP_CPU_PROCESSES"
echo ""

echo -e "${CYAN}--- Top 5 Processes (by RAM) ---${NC}"
echo "$TOP_MEM_PROCESSES"
echo ""

echo -e "${CYAN}--- Top 5 Active Connections ---${NC}"
echo "Proto Recv-Q Send-Q Local Address:Port Peer Address:Port User"
echo "$ACTIVE_CONNECTIONS"

echo -e "${CYAN}------------------------------------------------------------${NC}"
