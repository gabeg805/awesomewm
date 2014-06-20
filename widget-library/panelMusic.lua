-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     panelMusic
-- 
-- 
-- Syntax: 
-- 	
--     panelMusic = require("panelMusic")
-- 
-- 
-- Purpose:
-- 	
--     Returns the music widget so that the user can it on the panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     panelMusic.getIcon - returns the music icon
--     musicTitle         - returns the song title
--     musicTotalTime     - returns the total song length
--     musicCurrTime      - returns the current song time
--     musicSong          - returns the entire song name (artist and title)
--     disp_musicMenu     - display all the music information as a popup
--     musicTimer         - enables the timer to display the popup every second 
--                          or any amount of time you choose (in aweInterface) 
--     panelMusic.music   - returns the music player widget (image and text)
-- 
-- 
-- Dependencies:
--
--     awful     - Awesome builtin module
-- 
--     mocp      - installed music player (you can choose any you want, 
--                 just change "mocp" below to whatever your's is called), 
--                 package installed with 'sudo pacman -S moc'
--     panelText - custom module, returns script output as a string or as text
--                 for a widget 
--   
--   
--  File Structure:
--
--     * Import Modules
--     * Define Necessary Variables
--     * Define the Module
--     * Create the Awesome Launcher
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 23 2014 <> created
--
-- ************************************************************************



-- **************
-- IMPORT MODULES 
-- **************

local panelText = require("panelText")



-- **************************
-- DEFINE NECESSARY VARIABLES
-- **************************

-- icons to display
local musicIcon = "/home/gabeg/.config/awesome/icons/music.png"



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
-- CREATE THE MUSIC WIDGET
-- ***********************

panelMusic = make_module('panelMusic',
                        function(panelMusic)
                            
                            -- set the music player widget icon
                            panelMusic.getIcon = function(myMusicImage, output)
                                if output == "" then
                                    myMusicImage:set_image()
                                else
                                    myMusicImage:set_image(musicIcon)
                                end
                            end
                            
                            
                            -- get the song title
                            function musicTitle()
                                local cmd = "mocp -i | grep -m 1 Title | cut -f2 -d':' | sed 's/^[ \t]*//'"
                                local title = panelText.subGetPipeScript(cmd)
                                
                                return title
                            end
                            
                            
                            -- get the total length of the song
                            function musicTotalTime()
                                local cmd = "mocp -i | grep -m 1 TotalTime | cut -f2 -d' '"
                                local totalTime = panelText.pipe(cmd)
                                
                                return totalTime
                            end
                            
                            
                            -- get the current time of the song
                            function musicCurrTime()
                                local cmd = "mocp -i | grep -m 1 CurrentTime | cut -f2 -d' '"
                                local currTime = panelText.pipe(cmd)
                                
                                return currTime
                            end
                            
                            
                            -- get the entire song name (title and artist)
                            function musicSong()
                                local title = musicTitle()
                                local totalTime = musicTotalTime()
                                local currTime = musicCurrTime()
                                    
                                local output = title .. "   " .. currTime .. "/" .. totalTime .. "  " 
                                
                                if title == nil or currTime == nil or totalTime == nil then 
                                    return nil
                                end
                                
                                return output
                            end
                            
                            
                            -- display all the music information as a popup
                            function disp_musicMenu()
                                local mocpRun = panelText.subGetScript("pgrep -c mocp") + 0
                                
                                if songMenu ~= nil then naughty.destroy(songMenu) end 
                                
                                if mocpRun > 0 then
                                    naughty.destroy(songMenu)
                                    
                                    song = musicSong()
                                    
                                    if song == nil then 
                                        naughty.notify( { text = "Loading...",
                                                          font = "Inconsolata 10",
                                                          position = "bottom_right",
                                                          timeout = 0, hover_timeout = 0
                                                        }
                                                      ) 
                                    else
                                        songMenu = naughty.notify( { text = song,
                                                                     font = "Inconsolata 10",
                                                                     position = "bottom_right",
                                                                     timeout = 0, hover_timeout = 0
                                                                   } )
                                    end
                                end
                            end
                            
                            
                            -- shows the popup on a timer (every second)
                            function musicTimer(seconds)
                                myMusicTimer = timer({ timeout = seconds })
                                myMusicTimer:connect_signal("timeout", function() disp_musicMenu() end)
                                myMusicTimer:start()                                
                            end
                            
                            
                                                        
                            -- music player popup
                            panelMusic.music = function()
                                if songMenu ~= nil then naughty.destroy(songMenu) end 
                                disp_musicMenu()
                            end
                            
                            end
                       )