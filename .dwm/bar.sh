#!/bin/bash

# temps
temp_date="$HOME/.dwm/tmp/date"
temp_mem="$HOME/.dwm/tmp/mem"
temp_storage="$HOME/.dwm/tmp/storage"
temp_battery="$HOME/.dwm/tmp/battery"
temp_wifi="$HOME/.dwm/tmp/wifi"
temp_cpu="$HOME/.dwm/tmp/cpu"
temp_vol="$HOME/.dwm/tmp/vol"


# date
while true; do
  w=$(date "+%w")
  Week=""
  case $w in
    0) # Sunday
      Week="Sun"
      ;;
    1) # Monday
      Week="Mon"
      ;;
    2) # Tuesday
      Week="Tue"
      ;;
    3) # Wednesday
      Week="Wed"
      ;;
    4) # Thursday
      Week="Thu"
      ;;
    5) # Friday
      Week="Fri"
      ;;
    6) # Saturday
      Week="Sat"
      ;;
  esac
  date_info=$(date "+%Y-%m-%d $Week %H:%M:%S")
  echo "$date_info" > "$temp_date"  # 将最新的日期信息写入临时文件
  sleep 1
done &

# storage
while true; do
  storage=$(df / | awk 'NR==2 {print $5}')
  echo "$storage" > "$temp_storage"
  sleep 60
done &

# battery
while true; do
  battery=$(acpi -b | grep -P -o '[0-9]+(?=%)')
  echo "$battery" > "$temp_battery"
  sleep 30
done &

# vol
while true; do
  vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | cut -d'.' -f2) 
  
  Vol=""
  if [ $vol -ge 50 ]
  then
    Vol=" "
  elif [ $vol -eq 0 ]
  then
    Vol=" "
  else
    Vol=" "
  fi
  MAC=$(bluetoothctl devices | grep -i Baseus | awk '{print $2}' | head -n 1)
  Blue_bat=$(bluetoothctl info "$MAC" | grep Battery | awk '{print $4}' | tr -d '()')
  if_con=$(bluetoothctl info "$MAC" | grep Connected | awk '{print $2}')
  
  Blue_icon=""
  if [ "$if_con" = "yes" ]; then
    case $Blue_bat in
      100)
        Blue_icon="󰥈 "
        ;;
      90)
        Blue_icon="󰥆 "
        ;;
      80)
        Blue_icon="󰥅 "
        ;;
      70)
        Blue_icon="󰥄 "
        ;;
      60)
        Blue_icon="󰥃 "
        ;;
      50)
        Blue_icon="󰥂 "
        ;;
      40)
        Blue_icon="󰥁 "
        ;;
      30)
        Blue_icon="󰥀 "
        ;;
      20)
        Blue_icon="󰤿 "
        ;;
      10)
        Blue_icon="󰤾 "
        ;;
      esac
  else
    Blue_icon=""
  fi
  echo "$Blue_icon$Vol$vol" > "$temp_vol"
  sleep 10
done &

# mem
while true; do
  mem=$(free -h | grep "内存：" | awk '{printf "%.0f%%\n", $3/$2*100}')
  echo "$mem" > "$temp_mem"
  sleep 5
done &

# cpu
while true; do
  cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
  echo "$cpu" > "$temp_cpu"
  sleep 5
done &

# wifi
while true; do
  wifi=$(nmcli -t -f active,ssid dev wifi | grep '是' | cut -d':' -f2 | awk '{print $1}')
  Net_status=""
  Curl=$(curl -s --connect-timeout 2 --head http://www.baidu.com | head -n 1 | grep "HTTP/1"|awk '{print $2}')
  if [ $Curl -eq 200 ]
  then
    Net_status=" 󰌘"
  else
    Net_status=" 󰌙"
  fi
  echo "$wifi$Net_status" > "$temp_wifi"
  sleep 5
done &


# 读取临时文件并输出
while true; do
  if [[ -f "$temp_date" ]]; then
    date=$(cat $temp_date)
  fi
  if [[ -f "$temp_cpu" ]]; then
    cpu=$(cat $temp_cpu)
  fi
  if [[ -f "$temp_mem" ]]; then
    mem=$(cat $temp_mem)
  fi
  if [[ -f "$temp_storage" ]]; then
    storage=$(cat $temp_storage)
  fi
  if [[ -f "$temp_battery" ]]; then
    battery=$(cat $temp_battery)
  fi
  if [[ -f "$temp_wifi" ]]; then
    vol=$(cat $temp_vol)
  fi
  if [[ -f "$temp_vol" ]]; then
    wifi=$(cat $temp_wifi)
  fi
  xsetroot -name "/ $storage |  $cpu |  $mem |  $battery% | $vol% |  $wifi | $date"
  sleep 1
done &
