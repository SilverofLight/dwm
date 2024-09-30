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
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d'.' -f2) 

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

# 将信息输出到状态栏
xsetroot -name "/ $storage |  $cpu |  $mem |  $battery% | $Vol$vol% |  $wifi | $date_info"
