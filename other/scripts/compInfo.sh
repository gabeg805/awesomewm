#!/bin/bash

mainBatFile='/sys/class/power_supply/BAT0'
mainBrightFile='/mnt/Linux/Share/scripts/system'

case "$1" in
    "bat")
           if [[ "$2" == 'stat' ]]; then 
               chargeStatus=`head -1 "$mainBatFile/status"`
               echo "$chargeStatus"
               exit
           fi
           
           currentCharge=`head -1 "$mainBatFile/charge_now"`
           fullCharge=`head -1 "$mainBatFile/charge_full"`
           batUsed=`echo "scale=3; $currentCharge / $fullCharge * 100" | bc | sed 's/..$//'`
           
           echo "$batUsed% "
           ;;

 "bright")
           currBright=`$mainBrightFile/BRIGHT_ARCH status | cut -f2 -d':' | sed 's/^[ \t]*//'`
           maxBright=4882
           
           if [[ "$2" == 'stat' ]]; then
               value=`echo "$currBright * 100 / $maxBright" | bc`
               echo "$value% "
               exit
           elif [[ "$2" == 'stat-bare' ]]; then
               value=`echo "$currBright * 100 / $maxBright" | bc`
               echo "$value"
               exit
           elif [ "$2" -eq "$2" ] 2>/dev/null; then
               if [ "$2" -ge 1 -a "$2" -le 100 ]; then 
                   value=`echo "scale=2; $maxBright / 100 * $2" | bc`
                   rounded=`echo "$value/1" | bc`
                   sudo "$mainBrightFile/BRIGHT_ARCH" "$rounded" > /dev/null
               fi               
           fi
           ;;
        
    "cpu")
           # Calucalte CPU Info
           ALLcpuUsed=(`mpstat -P ALL | tail -4 | awk ' { print 100 - $13 } '`)
           
           cpu0Used=${ALLcpuUsed[0]}
           cpu1Used=${ALLcpuUsed[1]}
           cpu2Used=${ALLcpuUsed[2]}
           cpu3Used=${ALLcpuUsed[3]}
           
           
           # Display Information
           echo "CPU 0: $cpu0Used%"
           echo "CPU 1: $cpu1Used%"
           echo "CPU 2: $cpu2Used%"
           echo "CPU 3: $cpu3Used%"
           ;;

    "mem")
           memTotal=`head -1 /proc/meminfo | awk ' { print $2 } '`
           memFree=`head -2  /proc/meminfo | tail -1 | awk ' { print $2 } '`
           memPer=`echo "scale=3; ( $memTotal - $memFree ) / $memTotal * 100" | bc | sed 's/.$//'`
           
           memUsed=`echo "$memTotal  $memFree" | awk ' { print ($1 - $2 )/1000 } ' | sed 's/..$//'` 
           memOverall=`echo $memTotal | awk ' { print $1 / 1000000 } ' | sed 's/...$//'`
           
           echo "Mem: $memUsed Mb / $memOverall Gb"
           ;;

    "net")
           if [[ "$2" == 'ssid' ]]; then 
               ssid=`iw dev wlp1s0 link | grep SSID | cut -f2 -d':' | sed 's/^[ \t]*//'`
               echo "SSID: $ssid"
               exit
           fi
           
           wirelessInfo=`tail -1 /proc/net/wireless`
           link=`echo $wirelessInfo | awk ' { print $3 } '`
           dbm=`echo $wirelessInfo | awk ' { print $4 } '`
           
           sigQuality=`echo "scale=3; ( $link + 30 + $dbm ) / $link * 100.0" | bc | sed 's/.$//'`
           
           if (( $(bc <<< "$sigQuality > 1") == 1 )) 2>/dev/null; then
               echo "$sigQuality% "
           else
               echo "Searching... "
           fi
           ;;

   "temp")
           # Caluclate Computer Temp
           tempUnits='°C'
           allTemp=(`sensors | cut -s -f2 -d'+' | sed 's/°C.*$//'`)
           avgTemp=0.0
           for i in "${allTemp[@]}"; do 
               avgTemp=`echo $avgTemp $i | awk ' { print $1 + $2/6 } '`
           done
           
           len=`echo $avgTemp | wc -c`
           if [ $len -gt 6 ]; then 
               avgTemp=`echo $avgTemp | sed 's/..$//'`
           fi
           
           echo "Temp: $avgTemp$tempUnits"           
           ;;
    
    "up")
          runTime=`uptime | awk ' { print $3 } ' | sed 's/\,//'`          
          echo "Uptime: $runTime"
          ;;
    
   "vol") 
          if [[ "$2" == 'stat' ]]; then
              currVol=`amixer get Master | tail -1 | awk '{print $4}' | sed -e 's/\[//; s/\]//'`
              echo "$currVol "
              exit
          elif [ "$2" -eq "$2" ] 2>/dev/null; then
              if [ "$2" -ge 0 -a "$2" -le 100 ]; then
                  scale=1.149425
                  
                  value=`echo "scale=3; $2/$scale" | bc`
                  rounded=`echo $value/1 | bc`
                  
                  amixer -q cset iface=MIXER,name="Master Playback Volume" "$rounded"
              fi
          fi
          
          ;;
esac

