#!/bin/bash
# 
# Created By: Gabriel Gonzalez
# 
# 
# Name:
# 	
#     compInfo-Arch
# 
# 
# Syntax: 
# 	
#     compInfo-Arch 
#             [ -h ]
#             [ bat [NULL] [stat] ] 
#             [ bright [stat] [stat-val] [VALUE] ] 
#             [cpu [NULL] ] 
#             [mem [NULL] ] 
#             [ net [NULL] [ssid] ] 
#             [temp [NULL] ] 
#             [up [NULL] ] 
#             [ vol [stat] [muteStat] [unmute] [VALUE] ]
# 
# 
# Purpose:
# 	
#     Displays a wide variety of computer information on the Arch Linux 
#     operating system. 
#     
#     * Verified on a Dell Inspiron 14R running Arch Kernel release 3.13.5-1.
# 
# 
# Keywords:
#     
# 	  -h     - show the help screen
#     bat    - displays the current battery percentage, the option 'stat' is 
#              used to show whether or not the charger is plugged in 
#              (can be run with no arguments) 
#     bright - prints the current brightness percentage with 'stat', the current
#              brightness value with 'stat-val', or changes the brightness to VALUE
#              where VALUE is a number from 1 - 100
#              (cannot be run without arguments)
#     cpu    - displays the current cpu frequency as a percentage for each cpu
#              (run with no arguments)
#     mem    - shows the current memory usage  out of the total amount of memory (Mb)
#              (run with no arguments)
#     net    - displays the current network strength as a percentgage, with the 
#              option 'ssid', prints the ssid of the network that the computer is
#              connected to
#              (can be run with no arguments)
#     temp   - prints the current temperature of the computer (degrees Celcius)
#              (run with no arguments)
#     up     - prints the current "uptime" of the computer
#              (run with no arguments)
#     vol    - displays the current volume setting as a percentage with the option
#              'stat', shows the status of mute (whether it's toggled or not) with
#              'muteStat', unmutes the sound card with 'unmute', or changes the 
#              volume to the VALUE specified where VALUE is a number from 0 - 100
# 
# 
# Functions:
# 	
#     N/A
# 
# 
# Dependencies:
#
#     sensors - installed function, installed with 'sudo pacman -S lm-sensors'
#   
#   
# Modification History:
# 	
#     gabeg Mar 24 2014 <> created
#
# ************************************************************************




# **************************************
# DISPLAY REQUESTED COMPUTER INFORMATION
# **************************************

# Show Help Screen
if [[ "$1" == '-h' ]]; then
    head -75 `which compInfo-Arch.sh` | less
fi

# Show Everything Else!
case "$1" in


# Battery Information
    "bat")
           mainBatFile='/sys/class/power_supply/BAT0'
           
           case "$2" in
               '')  ;;
               
               'stat')
                       chargeStatus=`head -1 "$mainBatFile/status"`
                       echo "$chargeStatus"
                       exit
                       ;;
               *)
                  synloc=`echo $0`
                  syntax "$synloc" 10
                  exit
                  ;;
           esac
           
           currentCharge=`head -1 "$mainBatFile/charge_now"`
           fullCharge=`head -1 "$mainBatFile/charge_full"`
           batUsed=`echo "scale=3; $currentCharge / $fullCharge * 100" | bc | sed 's/..$//'`
           
           echo "$batUsed% "
           ;;


# Brightness Settings
 "bright")
           mainBrightFile='/mnt/Linux/Share/scripts/system'
           
           currBright=`$mainBrightFile/BRIGHT status | cut -f2 -d':' | sed 's/^[ \t]*//'`
           maxBright=4882
           
           if [ "$2" -eq "$2" ] 2>/dev/null; then
               if [ "$2" -ge 1 -a "$2" -le 100 ]; then 
                   value=`echo "scale=2; $maxBright / 100 * $2" | bc`
                   rounded=`echo "$value/1" | bc`
                   sudo "$mainBrightFile/BRIGHT" "$rounded" > /dev/null
               fi               
           fi
           
           case "$2" in
               'stat')
                       value=`echo "$currBright * 100 / $maxBright" | bc`
                       echo "$value% "
                       exit
                       ;;
           'stat-val')
                       echo "$currBright"
                       exit
                       ;;
               *)
                  synloc=`echo $0`
                  syntax "$synloc" 10
                  exit
                  ;;
           esac
           ;;
    
    
# CPU Information        
    "cpu")
           # Calucalte CPU Info
           ALLcpuUsed=(`mpstat -P ALL | tail -4 | awk ' { print 100 - $13 } '`)
           
           cpu0Used=${ALLcpuUsed[0]}
           cpu1Used=${ALLcpuUsed[1]}
           cpu2Used=${ALLcpuUsed[2]}
           cpu3Used=${ALLcpuUsed[3]}
           
           case "$2" in
               '')
                   # Display Information
                   echo "CPU 0: $cpu0Used%"
                   echo "CPU 1: $cpu1Used%"
                   echo "CPU 2: $cpu2Used%"
                   echo "CPU 3: $cpu3Used%"
                   ;;
               *)
                  synloc=`echo $0`
                  syntax "$synloc" 10
                  exit
                  ;;
           esac
           ;;
    

# Memory Usage Stats
    "mem")
           memTotal=`head -1 /proc/meminfo | awk ' { print $2 } '`
           memFree=`head -2  /proc/meminfo | tail -1 | awk ' { print $2 } '`
           memPer=`echo "scale=2; ( $memTotal - $memFree ) / $memTotal * 100" | bc`
           
           memUsed=`echo "scale=1; ($memTotal - $memFree) / 1000" | bc` 
           memOverall=`echo "scale=0; $memTotal/1000" | bc`

           case "$2" in
               '')
                   echo "Mem: $memUsed Mb / $memOverall Mb"
                   ;;
               *)
                  synloc=`echo $0`
                  syntax "$synloc" 10
                  exit
                  ;;
           esac           
           ;;


# Network Connectivity
    "net")
           case "$2" in
               '')
                   wirelessInfo=`tail -1 /proc/net/wireless`
                   link=`echo $wirelessInfo | awk ' { print $3 } '`
                   dbm=`echo $wirelessInfo | awk ' { print $4 } '`
                   
                   sigQuality=`echo "scale=3; ( 100 + $dbm ) / $link * 100.0" | bc | sed 's/.$//'`
                   
                   if (( $(bc <<< "$sigQuality > 1") == 1 )) 2>/dev/null; then
                       echo "$sigQuality% "
                   else
                       echo "Searching... "
                   fi
                   ;;

               'ssid')
                       ssid=`iw dev wlp1s0 link | grep SSID | cut -f2 -d':' | sed 's/^[ \t]*//'`
                       echo "SSID: $ssid"
                       exit
                       ;;
               *)
                  synloc=`echo $0`
                  syntax "$synloc" 10
                  exit
                  ;;
           esac
           ;;


# Computer Temperature
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


# Uptime of Computer    
    "up")
          case "$2" in
              '')
                  runTime=`uptime | awk ' { print $3 } ' | sed 's/\,//'`          
                  echo "Uptime: $runTime"
                  ;;
              *)
                 synloc=`echo $0`
                 syntax "$synloc" 10
                 exit
                 ;;
          esac
          ;;
    

# Volume Settings
   "vol") 
          
          if [ "$2" -eq "$2" ] 2>/dev/null; then
              if [ "$2" -ge 0 -a "$2" -le 100 ]; then
                  scale=1.149425
                  
                  value=`echo "scale=3; $2/$scale" | bc`
                  rounded=`echo $value/1 | bc`
                  
                  amixer -q cset iface=MIXER,name="Master Playback Volume" "$rounded"
              fi
          fi
          
          
          case "$2" in
              '')
                  runTime=`uptime | awk ' { print $3 } ' | sed 's/\,//'`          
                  echo "Uptime: $runTime"
                  ;;
          'stat')
                  currVol=`amixer get Master | tail -1 | awk '{print $4}' | sed -e 's/\[//; s/\]//'`
                  echo "$currVol "
                  exit
                  ;;
      'muteStat')
                  currMuteStat=`amixer get Master | tail -1 | awk ' { print $6 } ' | sed 's/\[//; s/\]//'`
                  echo "$currMuteStat"
                  exit
                  ;;
        'unmute')
                  amixer sset Master unmute
                  exit
                  ;;
              
              *)
                  synloc=`echo $0`
                  syntax "$synloc" 10
                  exit
                  ;;
          esac          
          ;;
esac

