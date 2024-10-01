#!/bin/bash
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
# cpu
cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
# Mem
mem=$(free -h | grep "内存：" | awk '{printf "%.0f%%\n", $3/$2*100}')
# stroge
storage=$(df / | awk 'NR==2 {print $5}')
# 获取电量
battery=$(acpi -b | grep -P -o '[0-9]+(?=%)')
# 获取 WiFi 信息
wifi=$(nmcli -t -f active,ssid dev wifi | grep '是' | cut -d':' -f2 | awk '{print $1}')
# 获取当前日期
date_info=$(date "+%Y-%m-%d $Week %H:%M:%S")
# date_info=$(date "+%m-%d %H:%M")

#获取音量
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

# 判断网络状态
Net_status=""
Curl=$(curl -s --connect-timeout 2 --head http://www.baidu.com | head -n 1 | grep "HTTP/1"|awk '{print $2}')

if [ $Curl -eq 200 ]
then
  Net_status=" 󰌘"
else
  Net_status=" 󰌙"
fi

# 将信息输出到状态栏
xsetroot -name "/ $storage |  $cpu |  $mem |  $battery% | $Blue_icon$Vol$vol% |  $wifi$Net_status | $date_info"
