-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     panelVolume
-- 
-- 
-- Syntax: 
-- 	
--     panelVolume = require("panelVolume")
-- 
-- 
-- Purpose:
-- 	
--     Returns the volume widget so that the user can put it on the panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     panelVolume.getIcon - returns the correct volume icon given the current
--                           volume percentage value
--     panelVolume.click   - makes the volume widget clickable
--     remove_calendar     - removes the click-enabled calendar
--     add_calendar        - displays the click-enabled calendar
--     panelVolume.volume  - returns the volume widget (image and text)
-- 
-- 
-- Dependencies:
--
--     wibox - Awesome builtin module
-- 
--     panelText - custom module that converts the output from a script into
--                 a string or text for a widget 
--   
--   
--  File Structure:
--
--     * Import Modules 
--     * Define Necessary Variables
--     * Define the Module
--     * Create the Volume Widget
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



-- **************************
-- DEFINE NECESSARY VARIABLES
-- **************************

-- volume icons for different percentage values
local volMute = "/home/gabeg/.config/awesome/icons/vol/volMute.png"
local vol0 = "/home/gabeg/.config/awesome/icons/vol/vol0-35.png"
local vol35 = "/home/gabeg/.config/awesome/icons/vol/vol35-70.png"
local vol70 = "/home/gabeg/.config/awesome/icons/vol/vol70-100.png"

-- script that prints out current volume value
vol_cmd = "/mnt/Linux/Share/scripts/comp_info.sh vol stat"
chVol_cmd = "/mnt/Linux/Share/scripts/comp_info.sh vol "



-- *****************
-- DEFINE THE MODULE
-- *****************

function make_module(name, definer)
   local module = {}
   definer(module)
   package.loaded[name] = module
   return module
end
 



-- ************************
-- CREATE THE VOLUME WIDGET
-- ************************

panelVolume = make_module('panelVolume',
                          function(panelVolume)
                              
                              -- sets the icon image for the volume widget
                              panelVolume.getIcon = function(panel, command)
                                  local percent = panelText.subGetScript(vol_cmd)
                                  local subPercent = percent:gsub('%W','')
                                  
                                  subPercent = subPercent + 0
                                  if subPercent > 0 and subPercent < 35 then
                                      icon = vol0
                                  elseif subPercent >= 35 and subPercent < 70 then
                                      icon = vol35
                                  elseif subPercent >= 70 then
                                      icon = vol70
                                  end
                                  
                                  panel:set_image(icon)
                              end
                              
                              
                              
                              -- make volume widget clickable (display popup)
                              panelVolume.click = function(myVolume) 
                                  local volMenu = nil
                                  local temp = panelText.subGetScript(vol_cmd)
                                  
                                  local offset = temp:gsub('%W','') + 0
                                  
                                  -- remove the volMenu popup
                                  function remove_volMenu()
                                      if volMenu ~= nil then
                                          naughty.destroy(volMenu)
                                          volMenu = nil
                                          
                                          temp = panelText.subGetScript(vol_cmd)
                                          offset = temp:gsub('%W','') + 0
                                      end
                                  end
                                  
                                  
                                  -- display the volMenu popup
                                  function add_volMenu(incr)
                                      local saveOffset = offset
                                                                            
                                      remove_volMenu()
                                      
                                      offset = saveOffset + incr
                                      
                                      os.execute(chVol_cmd .. offset)
                                      volData = panelText.subGetScript(vol_cmd)
                                      
                                      volMenu = naughty.notify( { text = string.format('<span font_desc="%s">%s</span>', 
                                                                                       "Inconsolata 10",  
                                                                                       "Volume: " .. volData
                                                                                      ),
                                                                   timeout = 0, hover_timeout = 1,
                                                                   width = 110,
                                                                   height = 30,
                                                                 } )
                                  end
                                 
                                  
                                  
                                  -- enable mouse events for textclock widget
                                  myVolume:buttons( awful.util.table.join( 
                                                           awful.button({ }, 1, function () add_volMenu(0) end),
                                                           awful.button({ }, 4, function() add_volMenu(1) end),
                                                           awful.button({ }, 5, function() add_volMenu(-1)  end)
                                                                            )
                                                     )
                              end
                              
                              
                              
                              -- returns the volume widget (image and text)
                              panelVolume.volume = function()
                                  myVolumeImage = wibox.widget.imagebox()
                                  myVolumeTextBox = wibox.widget.textbox()
                                  
                                  panelVolume.getIcon(myVolumeImage, vol_cmd)
                                  panelText.getScript(myVolumeTextBox, vol_cmd, "#660099")
                                  panelVolume.click(myVolumeTextBox)
                                  
                                  return myVolumeImage, myVolumeTextBox
                              end
                              
                          end
                         )