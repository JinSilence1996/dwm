dwm - dynamic window manager
============================
dwm is an extremely fast, small, and dynamic window manager for X.


Requirements
------------
In order to build dwm you need the Xlib header files.


Installation
------------
Edit config.mk to match your local setup (dwm is installed into
the /usr/local namespace by default).

Afterwards enter the following command to build and install dwm (if
necessary as root):

    make clean install


Running dwm
-----------
Add the following line to your .xinitrc to start dwm using startx:

    exec dwm

In order to connect dwm to a specific display, make sure that
the DISPLAY environment variable is set correctly, e.g.:

    DISPLAY=foo.bar:1 exec dwm

(This will start dwm on display :1 of the host foo.bar.)

In order to display status info in the bar, you can do something
like this in your .xinitrc:

    while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
    do
    	sleep 1
    done &
    exec dwm

~/.dwm/autostart.sh
```sh
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
```

Configuration
-------------
The configuration of dwm is done by creating a custom config.h
and (re)compiling the source code.
