#!/bin/sh

bash ~/.config/status_crypto_coins/status_crypto.sh &

cpu_usage() {
  echo "CPU: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
}

mem_usage() {
  free | awk '/Mem/ {printf("MEM: %.2f%\n", $3/$2*100)}'
}

network_info() {
  for interface in /sys/class/net/*; do
      if [ -d "$interface" ]; then
          interface_name=$(basename "$interface")
          operstate=$(cat "$interface/operstate")

          if [ "$operstate" = "up" ]; then
              ip_address=$(ip -4 -o address show dev "$interface_name" | awk '{print $4}')
              echo "$interface_name: $ip_address"
          fi
      fi
  done
}

status_monitor() {
  xsetroot -name "$(cat ~/.config/status_crypto_coins/status_crypto.txt) | $(mem_usage) | $(cpu_usage) | $(network_info) | $(date '+%a %b %d %H:%M') | $(whoami)"
}

status_bar_info() {
  while true; do
    status_monitor
    sleep 1  
  done
}

feh --bg-scale ~/.wallpapers/indian_goddess.png

picom &

status_bar_info &

while type dwm >/dev/null; do dwm && continue || break; done
