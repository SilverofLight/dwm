#!/bin/bash
# stroge
storage=$(df / | awk 'NR==2 {print $5}')
# 获取电量
battery=$(acpi -b | grep -P -o '[0-9]+(?=%)')
# 获取 WiFi 信息
wifi=$(nmcli -t -f active,ssid dev wifi | grep '是' | cut -d':' -f2 | awk '{print $1}')
ip=$(nmcli device show | grep IP4 | awk 'NR==1 {print $2}'|cut -d'/' -f1)
# 获取当前日期
date_info=$(date "+%Y-%m-%d %H:%M:%S")
# date_info=$(date "+%m-%d %H:%M")

#获取音量
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d'.' -f2) 

# 将信息输出到状态栏
xsetroot -name "/ $storage | Bat $battery% | Vol $vol% | WiFi $wifi $ip | $date_info"
