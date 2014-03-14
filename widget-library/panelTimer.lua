-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     panelTimer
-- 
-- 
-- Syntax: 
-- 	
--     panelTimer = require("panelTimer")
-- 
-- 
-- Purpose:
-- 	
--     Enables the widget timer so that widgets refresh with updated values.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     panelTimer.timer - refreshes widgets with updated values on a timer
-- 
-- 
-- Dependencies:
--
--     awful - Awesome builtin module
--     
--     panelText     - custom module, returns script output in string format or
--                     as text for a widget
--     panelBattery  - custom module, returns battery widget (image and text)
--     panelWireless - custom module, returns wifi widget (image and text)
--     panelVolume   - custom module, returns volume widget (image and text)
--   
--   
--  File Structure:
--
--     * Import Modules
--     * Script Output
--     * Define the Module
--     * Create the Widget Timer
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
--
-- ************************************************************************



-- **************
-- IMPORT MODULES
-- **************

local panelText = require("panelText")
local panelBattery = require("panelBattery")
local panelWireless = require("panelWireless")
local panelVolume = require("panelVolume")



-- *************
-- SCRIPT OUTPUT
-- *************

-- script that prints out current computer info
bat_cmd = "/mnt/Linux/Share/scripts/comp_info.sh bat"
net_cmd = "/mnt/Linux/Share/scripts/comp_info.sh net"
vol_cmd = "/mnt/Linux/Share/scripts/comp_info.sh vol stat"



-- *****************
-- DEFINE THE MODULE
-- *****************

function make_module(name, definer)
    local module = {}
    definer(module)
    package.loaded[name] = module
    return module
end




-- ***********************
-- CREATE THE WIDGET TIMER
-- ***********************

panelTimer = make_module('panelTimer',
                         function(panelTimer)
                             
                             -- refreshes widgets with updated values
                             panelTimer.timer = function(myBatteryImage, myBatteryTextBox, myWirelessImage, myWirelessTextBox, myVolumeImage, myVolumeTextBox, myBrightnessTextBox, secs)
                                 mytimer = timer({ timeout = secs })
                                 mytimer:connect_signal("timeout", 
                                                        function()
                                                            panelBattery.warning()
                                                            
                                                            panelBattery.getIcon(myBatteryImage, bat_cmd)
                                                            panelText.getScript(myBatteryTextBox, bat_cmd, "#333333")
                                                            
                                                            panelWireless.getIcon(myWirelessImage, net_cmd)
                                                            panelText.getScript(myWirelessTextBox, net_cmd, "#006699")
                                                            
                                                            panelVolume.getIcon(myVolumeImage, vol_cmd)
                                                            panelText.getScript(myVolumeTextBox, vol_cmd, "#660099")
                                                            
                                                            
                                                            panelText.getScript(myBrightnessTextBox, bright_cmd, "#ff3300")
                                                            
                                                        end
                                                       )
                                 mytimer:start()
                             end                             
                             
                         end
                        )