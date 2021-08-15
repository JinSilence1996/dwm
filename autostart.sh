#!/bin/sh

while true
do
    wlan_name="enp0s20f0u12"
    download_before=$(ifconfig $wlan_name | grep "RX packets" | awk '{print $5}')
    upload_before=$(ifconfig $wlan_name | grep "TX packets" | awk '{print $5}')
    
    sleep 1
    
    download_after=$(ifconfig $wlan_name | grep "RX packets" | awk '{print $5}')
    upload_after=$(ifconfig $wlan_name | grep "TX packets" | awk '{print $5}')
    
    upload_bits=$(expr $upload_after - $upload_before)
    download_bits=$(expr $download_after - $download_before)
    upload_bits=$(echo "scale=2; $upload_bits / 1024" | bc)
    download_bits=$(echo "scale=2; $download_bits / 1024" | bc)
    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
    VOL=$( amixer get Master | tail -1 | awk '{print $5}'  )
    TMP="$(cat /sys/class/thermal/thermal_zone0/temp)"
    CPU="$(uptime | sed 's/.*, //')"
    let "TEMP=($TMP/1000)"
    xsetroot -name "$(date '+%Y年%m月%d日 %a %T') V:$VOL B:[$BAT%] T:[$TEMP] CPU:[$CPU] download:[$download_bits kb/s] upload:[$upload_bits kb/s]"
done
