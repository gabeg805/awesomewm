======
README
======

What is it?
-----------

This directory contains the configuration files for the Awesome WM on Arch Linux. 
These configuration files control the wallpaper, keybindings, tiling layouts, 
workspaces, and panel customization. You can check out how my Awesome configuration 
looks like by going into the directory 'other/screenshots/'. My Awesome setup
has 6 widgets in all:
    - Awesome Menu
    - Clock
    - Brightness
    - Volume
    - Wifi
    - Battery

Each of these widgets has mouse events that are activated by hovering or clicking
on the widget. The following explains what those mouse events are:
    - Awesome Menu: Left mouse click displays the Awesome menu
    - Clock: Mouse hover displays the calendar, you can change month by scrolling
    - Brightness: Mouse hover displays the brightness level, you can change  
                  brightness by scrolling
    - Volume: Mouse hover displays volume level and (if music player is running) 
              current playing song, you can change volume by scrolling
    - Wifi: Mouse hover displays current connected wifi SSID and signal strength
    - Battery: Mouse hover displays battery tatus, charge level, and time remaining, 
               on right mouse click, uptime, memory usage and cpu usage is displayed
               and on left mouse click the mouse hover notification is displayed


Documentation
-------------

The documentation for each script is available in the headers of each respective
script.


Installation
------------

1) Copy and paste all the files into your '~/.config/awesome/' directory. 

2) To make sure my Awesome configuration files are compatible with your system, 
   run the 'other/scripts/awesetup' script. Make sure you are in the directory
   with the script and type in:
        $ ./awesetup

3) Enjoy your new Awesome setup!


- Note: if a problem occurs with the scripts, make sure they are executable and that 
they are in your $PATH environment variable.


Contacts
--------

If you have any problems, feel free to email me at 'gabeg@bu.edu'.


Potential Problems
------------------

The main issues that can arise are:
    - Missing dependencies 
    - Incorrect paths
    - Missing file/directory
    - Changing brightness error
    - Displaying battery error

To avoid these issues, run the 'other/scripts/awesetup' script to fix these problems. 
If your problem still hasn't been fixed, try and read the line number and error
in the error notification that shows up. 

For the brightness and battery error, the script path could be incorrect as it varies
from system to system, the paths in the files look like:
    '/sys/class/power_supply/BAT0/'
    '/sys/class/backlight/intel_backlight/'

Check your system for these files, if they aren't present, then fear not! They 
probably just have a different path, you can use something like:
    # find / -maxdepth 3 -name power_supply
    # find / -maxdepth 3 -name backlight

You can change the value 3 to be any number that you want, but the higher you go, 
the longer the search will take. Also, you can change the search name to be anything 
you want, you can even just leave it empty and user grep along side it, like this:
    # find / -maxdepth 3 | grep -i 'power_supply'
    # find / -maxdepth 3 | grep -i 'backlight'

If none of that helped, then you can always email me! 
Good luck! Hopefully your setup is error free!
