-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     bindFuncs
-- 
-- 
-- Syntax: 
-- 	
--     bindfuncs = require("bindFuncs")
-- 
-- 
-- Purpose:
-- 	
--     Returns the functions needed for screen brightness and volume keyboard 
--     keys to change the panel widgets.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     bindFuncs.signalBright - signals the brightness icon to change with the 
--                              changing brightness
--     bindFuncs.signalVolume - signals the volume icon to change with the 
--                              changing volume
-- 
-- 
-- Dependencies:
--
--     awful   - Awesome builtin module
--     naughty - Awesome builtin module
--     wibox   - Awesome builtin module
-- 
--     panelText        - custom module that converts the output from a script
--                        into a string or text for a widget 
--     panelBrightness  - custom module, returns brightness widget
--     panelVolume      - custom module, returns volume widget
--     compInfo-Arch.sh - custom script, displays a wide variety of computer
--                        information
--   
--   
--  File Structure:
--
--     * Import Modules 
--     * Define the Module
--     * Create the KeyBind Functions
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 22 2014 <> created
--
-- ************************************************************************



-- **************
-- IMPORT MODULES
-- **************

local panelText = require("panelText")
local panelVolume = require("panelVolume")



-- *****************
-- DEFINE THE MODULE
-- *****************

function make_module(name, definer)
    local module = {}
    definer(module)
    package.loaded[name] = module
    return module
end




-- *******************************
-- CREATE THE KEYBINDING FUNCTIONS
-- *******************************

bindFuncs = make_module('bindFuncs',
                          function(bindFuncs)
                              
                              -- Signals the brightness icon to change
                              bindFuncs.signalBright = function()
                                  
                                  -- Kill old brightness notification
                                  naughty.destroy(brightMenu)
                                  
                                  
                                  -- Display the notification
                                  local brightData = panelText.subGetScript(brightStat_cmd)
                                  brightMenu = naughty.notify( { text = "Brightness: " .. brightData,
                                                                 font = "Inconsolata 10", 
                                                                 timeout = 1, hover_timeout = 0,
                                                                 width = 130,
                                                                 height = 30
                                                               } )
                                  
                                  -- Change the icon
                                  panelBrightness.getIcon(myBrightnessImage, nil, brightData)
                              end
                              
                              
                              
                              
                              -- Signals the volume icon to change
                              bindFuncs.signalVolume = function(sig)
                                  
                                  -- Kill old volume notification
                                  naughty.destroy(volMenu)
                                  
                                  -- Notification bubble width
                                  wide = 110
                                  
                                  -- Get volume data
                                  local volData = panelText.subGetScript(vol_cmd)
                                  
                                  
                                  -- Change the volume
                                  if sig == "up" then
                                      awful.util.spawn("amixer -c 0 set Master 5+ unmute") 
                                      volData = panelText.subGetScript(vol_cmd)
                                                                            
                                  elseif sig == "down" then
                                      awful.util.spawn("amixer -c 0 set Master 5- unmute") 
                                      volData = panelText.subGetScript(vol_cmd)
                                                                            
                                  elseif sig == "mute" then
                                      awful.util.spawn("amixer -c 0 set Master toggle") 
                                      volData = panelText.subGetScript(vol_cmd)
                                      local muteTest = muteStat()
                                      
                                      if muteTest == "mute" then 
                                          volData = volData:gsub('%%', '%%  (Muted)')
                                          wide = 170
                                      end
                                  end
                                  
                                  
                                  -- Display the notification
                                  volMenu = naughty.notify( { text = "Volume: " .. volData, 
                                                              font = "Inconsolata 10", 
                                                              timeout = 1, hover_timeout = 0,
                                                              width = wide,
                                                              height = 30
                                                            } )
                                  
                                  
                                  -- Change the icon
                                  panelVolume.getIcon(myVolumeImage, vol_cmd)
                              end
                              
                          end
                         )
