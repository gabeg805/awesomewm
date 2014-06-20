-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
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
--     muteStat            - checks if mute is toggled
--     musicStat           - checks if MOCP (the music player) is running
--     getIcon             - returns icon path
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
--     panelMusic       - custom module for the music player
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

local panelMusic = require("panelMusic")
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
                              
                              -- Check if mute is toggled
                              function muteStat()

                                  -- Check if volume is muted
                                  local status = panelText.subGetScript(volMuteStat_cmd)
                                  status = string.sub(status, 2, 2)
                                  
                                  -- Initialize mute test variable
                                  local muteTest = nil
                                  
                                  if status == "f" then 
                                      muteTest = "mute" 
                                  elseif status == "n" then
                                      muteTest = "nomute"
                                  end
                                  
                                  return muteTest
                              end
                              
                              
                              -- Check if music is running
                              local function musicStat()
                                  local status = panelText.subGetScript(musicRunStat_cmd) + 0
                                  
                                  if status > 0 then
                                      musicTest = "music"
                                  else
                                      musicTest = "nomusic"
                                  end
                                  
                                  return musicTest
                              end
                              
                              
                              -- Return icon string
                              local function getIcon(command)
                                  local percent = panelText.subGetScript(command)
                                  local subPercent = percent:gsub('%%','') + 0
                                  local icon = nil
                                  
                                  local muteTest = muteStat()
                                  local musicTest = musicStat()
                                  
                                  
                                  -- Check if music is running
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
                                      
                                      -- Display non-music icons
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

                                  return icon
                              end
                              
                              
                              -- Set the icon image for the volume widget
                              panelVolume.getIcon = function(panel, command)
                                  local icon = getIcon(command)
                                  panel:set_image(icon)
                              end
                              
                              
                              -- Displays the volume notification
                              local function disp_volMenu(val)
                                  
                                  -- Kill old notification bubbles
                                  naughty.destroy(volMenu)
                                  
                                  -- Notification width
                                  wide = 110
                                  
                                  -- Notification volume data
                                  local volData = panelText.subGetScript(vol_cmd)
                                  
                                  -- Mute test
                                  local muteTest = muteStat()
                                  
                                  if muteTest == "mute" then 
                                      volData = volData:gsub('%%', '%%  (Muted)')
                                      wide = 170
                                  end
                                  
                                  
                                  -- Display the notification
                                  volMenu = naughty.notify( { text = "Volume: " .. volData, 
                                                              font = "Inconsolata 10", 
                                                              timeout = 0, hover_timeout = 0,
                                                              width = wide,
                                                              height = 30
                                                            } )
                              end
                              
                              
                              -- Make the popup increment volume with scrolling
                              panelVolume.hover = function(myVolumeLauncher, myMusicMenu) 
                                  local volMenu = nil
                                  local temp = panelText.subGetScript(vol_cmd)
                                  local offset = temp:gsub('%%','') + 0
                                  
                                  -- Display the volMenu popup
                                  function add_volMenu(incr)
                                      local saveOffset = offset
                                      offset = saveOffset + incr
                                      
                                      os.execute(chVol_cmd .. "  " .. offset)
                                      
                                      disp_volMenu(offset)
                                  end
                                  
                                  
                                  -- Enable mouse events for textclock widget
                                  myVolumeLauncher:buttons( awful.util.table.join( 
                                                                awful.button({ }, 1, function() myMusicMenu:toggle() end), 
                                                                awful.button({ }, 4, function() add_volMenu(1) end),
                                                                awful.button({ }, 5, function() add_volMenu(-1) end) ) 
                                                       )
                                  
                              end
                              
                              
                              
                              
                              
                              -- Returns the volume widget (image and text)
                              panelVolume.volume = function()
                                  
                                  -- Create the menu for a laucher widget 
                                  myMusicMenu = awful.menu( { items = {
                                                                  { "Play/Pause Song",    musicPause    },
                                                                  { "Play Next Song",     musicNextSong },
                                                                  { "Play Previous Song", musicPrevSong },
                                                                  { "Replay Playlist",    musicReplay    },
                                                                  { "Exit Music Player",  musicExit     }
                                                                      }, 
                                                              theme = { width = 300, height = 30 } 
                                                            } )
                                  
                                  
                                  -- Create the Launcher
                                  local volumeIcon = getIcon(vol_cmd)
                                  myVolumeLauncher = awful.widget.launcher( { image = volumeIcon, menu = myMusicMenu} )
                                  
                                  
                                  
                                  -- Enable mouse events for launcher
                                  myVolumeLauncher:connect_signal("mouse::enter", 
                                                                  function() 
                                                                      
                                                                      -- Reset volume icon
                                                                      volumeIcon = getIcon(vol_cmd)
                                                                      myVolumeLauncher:set_image(volumeIcon)
                                                                      
                                                                      -- Enable mouse hover events
                                                                      panelVolume.hover(myVolumeLauncher, myMusicMenu)
                                                                      disp_volMenu(0)
                                                                      panelMusic.music()  
                                                                  end
                                                                 )
                                  
                                  myVolumeLauncher:connect_signal("mouse::leave", 
                                                                  function() 
                                                                      naughty.destroy(volMenu)
                                                                      naughty.destroy(songMenu) 
                                                                  end
                                                                 ) 
                                  
                                  
                                  -- Return volume launcher
                                  return myVolumeLauncher
                              end
                              
                          end
                         )
