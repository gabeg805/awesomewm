===========
What is it?
===========

This directory contains the configuration files for the Awesome WM on Arch Linux. 
These configuration files control the wallpaper, keybindings, tiling layouts, 
workspaces, and panel customization. 



=============
Documentation
=============

My Awesome setup has 6 widgets in all:

    - Awesome Menu
    - Clock
    - Brightness
    - Volume
    - Wifi
    - Battery

Each of these widgets has mouse events that are activated by hovering or clicking
on the widget. The following explains what those mouse events are:

    - Awesome Menu: Left mouse click displays the Awesome menu

    - Clock:        Mouse hover displays the calendar, you can change month by scrolling

    - Brightness:   Mouse hover displays the brightness level, you can change  
                    brightness by scrolling

    - Volume:       Mouse hover displays volume level and (if music player is running) 
                    current playing song, you can change volume by scrolling

    - Wifi:         Mouse hover displays current connected wifi SSID and signal strength

    - Battery:      Mouse hover displays battery tatus, charge level, and time remaining, 
                    on right mouse click, uptime, memory usage and cpu usage is displayed
                    and on left mouse click the mouse hover notification is displayed

For more information on what each widget/config file does, check out their headers.



============
Installation
============

To install the Awesome WM config files, download the dependencies:

    # pacman -S sysstat
    # pacman -S lm_sensors
    # pacman -S acpi
    # pacman -S moc

Then execute the following:

    $ unzip Awesome-WM-master.zip
    $ mkdir -p ~/.config/awesome
    $ mv Awesome-WM-master/* ~/.config/awesome/
    $ rmdir Awesome-WM-master
    $ cd ~/.config/awesome/other/scripts
    $ ./setup

Enjoy!



========
Contacts
========

If you have any problems, feel free to email me at 'gabeg@bu.edu'.



==================
Potential Problems
==================

If problems arise, make sure that you ran the 'setup' to fix any dependency and path 
errors. If that didn't fix it, then perhaps your error is one of these:

    - Battery icon/value is not displaying. 
            * In the 'comp' script, there are hardcoded paths that look like:

                    '/sys/class/power_supply/BAT0/'

              Check your system for this file. If it is not present, then fear not! 
              It's probably just at a different path. If you execute:
                    
                    # find / -maxdepth 3 -iname 'power_supply'
              or
                    # find / -maxdepth 3 | grep -i 'power_supply'

              This will search for a file containing 'power_supply' starting at / and 
              going down to a depth of 3 levels. You can change the value 3 to be any
              number that you want, but the higher you go, the longer the search will 
              take. 

    - Brightness icon/value is not displaying. 
            * In the 'comp' script, there are hardcoded paths that look like:

                    '/sys/class/backlight/intel_backlight/'

              Check your system for this file. If it is not present, then fear not! 
              It's probably just at a different path. If you execute:
                    
                    # find / -maxdepth 3 -iname 'backlight'
              or
                    # find / -maxdepth 3 | grep -i 'backlight'

              This will search for a file containing 'backlight' starting at / and 
              going down to a depth of 3 levels. You can change the value 3 to be any
              number that you want, but the higher you go, the longer the search will 
              take. 

If none of that helped, then you can always email me! Good luck! Hopefully your 
setup is error free!
