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
--     Returns the functions needed for screen brightness and volume keyboard keys to change the panel widgets.
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
                              
                              -- signals the brightness icon to change
                              bindFuncs.signalBright = function(sig)
                                  naughty.destroy(brightMenu)
                                  
                                  if sig == "up" then
                                      awful.util.spawn("sudo /mnt/Linux/Share/scripts/system/BRIGHT up 100") 
                                  elseif sig == "down" then
                                      awful.util.spawn("sudo /mnt/Linux/Share/scripts/system/BRIGHT down 100") 
                                  end
                                  
                                  brightData = panelText.subGetScript(bright_cmd)
                                  brightMenu = naughty.notify( { text = "Brightness: " .. brightData,
                                                                 font = "Inconsolata 10", 
                                                                 timeout = 1, hover_timeout = 0,
                                                                 width = 130,
                                                                 height = 30,
                                                               } )
                                  
                                  panelBrightness.getIcon(myBrightnessImage, bright_cmd)

                              end

                              
                              -- signals the volume icon to change
                              bindFuncs.signalVolume = function(sig)
                                  naughty.destroy(volMenu)
                                  
                                  wide = 110
                                  volData = panelText.subGetScript(vol_cmd)
                                  
                                  if sig == "up" then
                                      awful.util.spawn("amixer -c 0 set Master 5+ unmute") 
                                  elseif sig == "down" then
                                      awful.util.spawn("amixer -c 0 set Master 5- unmute") 
                                  elseif sig == "mute" then
                                      awful.util.spawn("amixer -c 0 set Master toggle") 

                                      if muteTest ~= "mute" then 
                                          volData = volData:gsub('%%', '%%  (Muted)')
                                          wide = 160
                                      end
                                  end
                                  
                                  
                                  volMenu = naughty.notify( { text = "Volume: " .. volData, 
                                                              font = "Inconsolata 10", 
                                                              timeout = 1, hover_timeout = 0,
                                                              width = wide,
                                                              height = 30
                                                            } )
                                  
                                  
                                  panelVolume.getIcon(myVolumeImage, vol_cmd)
                              end
                              
                          end
                         )