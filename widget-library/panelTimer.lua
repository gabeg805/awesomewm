-- 
-- Created By: PERSON
-- 
-- 
-- Name:
-- 	
--     temp
-- 
-- 
-- Syntax: 
-- 	
--     temp [NULL]
-- 
-- 
-- Purpose:
-- 	
--     PURPOSE
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     N/A
-- 
-- 
-- Dependencies:
--
--     N/A
--   
--   
--  File Structure:
--
--     * N/A
-- 
-- 
-- Modification History:
-- 	
--     USR MON DAY YEAR <> created
--
-- ************************************************************************



-- **************************
-- DEFINE NECESSARY VARIABLES
-- **************************

-- script that prints out current computer info
net_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh net"
vol_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh vol stat"



local panelLayouts = require("panelLayouts")
local panelMenu = require("panelMenu")
local panelClock = require("panelClock")
local panelText = require("panelText")
local panelBattery = require("panelBattery")
local panelWireless = require("panelWireless")
local panelVolume = require("panelVolume")
local panelBrightness = require("panelBrightness")
local panelMusic = require("panelMusic")
local panelCute = require("panelCute")



-- ***********************
-- COMPILE ALL THE MODULES
-- ***********************

function make_module(name, definer)
   local module = {}
   definer(module)
   package.loaded[name] = module
   return module
end


gabegWidgets = make_module('gabegWidgets',
                           function(gabegWidgets)
                               
                               gabegWidgets.wallpaper = panelLayouts.wallpaper
                               gabegWidgets.layouts = panelLayouts.layouts
                               
                               gabegWidgets.aweMenu = panelMenu.aweMenu
                               gabegWidgets.clock = panelClock.clock
                               
                               gabegWidgets.battery = panelBattery.battery
                               gabegWidgets.wireless = panelWireless.wireless
                               gabegWidgets.volume = panelVolume.volume
                               gabegWidgets.brightness = panelBrightness.brightness
                               gabegWidgets.music = panelMusic.music
                               
                               gabegWidgets.cute = panelCute.cute
                               
                               -- enabling the timer to refresh widgets
                               gabegWidgets.setTimer = function(myBatteryImage, myBatteryTextBox, myWirelessImage, myVolumeImage, secs)
                                   mytimer = timer({ timeout = secs })
                                   mytimer:connect_signal("timeout", 
                                                          function()
                                                              -- refresh panel stats
                                                              panelBattery.warning()
                                                              panelBattery.getIcon(myBatteryImage, bat_cmd)
                                                              panelText.getScript(myBatteryTextBox, bat_cmd, "#333333")
                                                              panelWireless.getIcon(myWirelessImage, net_cmd)
                                                              panelVolume.getIcon(myVolumeImage, vol_cmd)
                                                              
                                                              -- increment/reset counter
                                                              counter = counter + 1
                                                              
                                                              if counter == 10 then
                                                                  naughty.notify( 
                                                                      { 
                                                                          preset = naughty.config.presets.critical,
                                                                          title = "Reminder",
                                                                          text = " 10 min",
                                                                          font = "Inconsolata 14", 
                                                                          position = "bottom_right", 
                                                                          timeout = 10, hover_timeout = 0,
                                                                          width = 90, 
                                                                          height = 60
                                                                      }
                                                                                )
                                                                  
                                                                  counter = 0
                                                              end
                                                              
                                                          end
                                                         )
                                   mytimer:start()
                               end                             
                               
                           end
                           
                          )

