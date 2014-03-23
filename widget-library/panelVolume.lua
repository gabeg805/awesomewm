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
--     disp_volMenu        - enables the popup
--     add_volMenu         - displays the hover-enabled popup
--     panelVolume.hover   - makes the volume widget hoverable
--     panelVolume.volume  - returns the volume widget 
-- 
-- 
-- Dependencies:
--
--     wibox - Awesome builtin module
-- 
--     panelText        - custom module that converts the output from a script
--                        into a string or text for a widget 
--     compInfo-Arch.sh - custom script, displays a wide variety of computer
--                        information
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
--     gabeg Mar 22 2014 <> removed widget text that would appear on the 
--                          panel and made it instead display in a popup.
--                          also made the popup appear when mouse hovers
--                          over the widget instead of by clicking
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
local vol0 = "/home/gabeg/.config/awesome/icons/vol/vol0-25.png"
local vol25 = "/home/gabeg/.config/awesome/icons/vol/vol25-50.png"
local vol50 = "/home/gabeg/.config/awesome/icons/vol/vol50-75.png"
local vol75 = "/home/gabeg/.config/awesome/icons/vol/vol75-100.png"

-- volume icons when music is playing
local volMusMute = "/home/gabeg/.config/awesome/icons/vol/volMusMute.png"
local volMus0 = "/home/gabeg/.config/awesome/icons/vol/volMus0-25.png"
local volMus25 = "/home/gabeg/.config/awesome/icons/vol/volMus25-50.png"
local volMus50 = "/home/gabeg/.config/awesome/icons/vol/volMus50-75.png"
local volMus75 = "/home/gabeg/.config/awesome/icons/vol/volMus75-100.png"


-- script that prints out current volume value
vol_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh vol stat"
chVol_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh vol "



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
                              panelVolume.getIcon = function(panel, command, muteTest, musicTest)
                                  local percent = panelText.subGetScript(command)
                                  local subPercent = percent:gsub('%%','')
                                  local icon = ""
                                  
                                  subPercent = subPercent + 0
                                  
                                  if musicTest == "music" then
                                      if muteTest == "mute" or subPercent == 0 then
                                          icon = volMusMute
                                      elseif subPercent > 0 and subPercent < 25 then
                                          icon = volMus0
                                      elseif subPercent >= 25 and subPercent < 50 then
                                          icon = volMus25
                                      elseif subPercent >= 50 and subPercent < 75 then
                                          icon = volMus50
                                      elseif subPercent >= 75 then
                                          icon = volMus75
                                      end
                                  else
                                      if muteTest == "mute" or subPercent == 0 then
                                          icon = volMute
                                      elseif subPercent > 0 and subPercent < 25 then
                                          icon = vol0
                                      elseif subPercent >= 25 and subPercent < 50 then
                                          icon = vol25
                                      elseif subPercent >= 50 and subPercent < 75 then
                                          icon = vol50
                                      elseif subPercent >= 75 then
                                          icon = vol75
                                      end
                                  end
                                  
                                  panel:set_image(icon)
                              end
                              
                              
                              -- displays the popup
                              function disp_volMenu(val)
                                  naughty.destroy(volMenu)

                                  volData = panelText.subGetScript(vol_cmd)
                                  
                                  volMenu = naughty.notify( { text = string.format('<span font_desc="%s">%s</span>',
                                                                                   "Inconsolata 10",  
                                                                                   "Volume: " .. volData
                                                                                  ),
                                                              timeout = 0, hover_timeout = 0,
                                                              width = 110,
                                                              height = 30
                                                            } )
                              end
                              
                              
                              -- make the popup increment volume with scrolling
                              panelVolume.hover = function(myVolumeImage) 
                                  local volMenu = nil
                                  local temp = panelText.subGetScript(vol_cmd)
                                  local offset = temp:gsub('%%','') + 0
                                  
                                  -- display the volMenu popup
                                  function add_volMenu(incr)
                                      local saveOffset = offset
                                      offset = saveOffset + incr
                                      
                                      os.execute(chVol_cmd .. offset)
                                      
                                      disp_volMenu(offset)
                                  end
                                 
                                  
                                  
                                  -- enable mouse events for textclock widget
                                  myVolumeImage:buttons( awful.util.table.join( 
                                                             awful.button({ }, 4, function() add_volMenu(1) end),
                                                             awful.button({ }, 5, function() add_volMenu(-1) end) ) 
                                                       )
                              end
                              
                              
                              
                              -- returns the volume widget (image and text)
                              panelVolume.volume = function()
                                  myVolumeImage = wibox.widget.imagebox()
                                  
                                  musicTest = panelText.subGetScript("pgrep -c mocp") + 0
                                  
                                  if musicTest > 0 then
                                      musicTest = "music"
                                  else
                                      musicTest = "no"
                                  end
                                  
                                  panelVolume.getIcon(myVolumeImage, vol_cmd, "unmute", musicTest)
                                  
                                  myVolumeImage:connect_signal("mouse::enter", function() panelVolume.hover(myVolumeImage); disp_volMenu(0)  end)
                                  myVolumeImage:connect_signal("mouse::leave", function() naughty.destroy(volMenu) end)                                 
                                  
                                  return myVolumeImage
                              end
                              
                          end
                         )