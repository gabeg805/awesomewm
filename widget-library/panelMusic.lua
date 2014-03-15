-- 
-- Created By: Gabriel Gonzalez
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
--     panelMusic.getIcon   - returns the music icon
--     panelMusic.title     - returns the song title
--     panelMusic.totalTime - returns the total song length
--     panelMusic.currTime  - returns the current song time
--     panelMusic.song      - returns the entire song name (artist and title)
--     panelMusic.music     - returns the music player widget (image and text)
-- 
-- 
-- Dependencies:
--
--     awful     - Awesome builtin module
-- 
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
                            panelMusic.title = function()
                                local cmd = "mocp -i | grep -m 1 Title | cut -f2 -d':' | sed 's/^[ \t]*//'"
                                local title = panelText.subGetPipeScript(cmd)
                                
                                return title
                            end
                            
                            
                            -- get the total length of the song
                            panelMusic.totalTime = function()
                                local cmd = "mocp -i | grep -m 1 TotalTime | cut -f2 -d' '"
                                local totalTime = panelText.pipe(cmd)
                                
                                return totalTime
                            end
                            
                            
                            -- get the current time of the song
                            panelMusic.currTime = function()
                                local cmd = "mocp -i | grep -m 1 CurrentTime | cut -f2 -d' '"
                                local currTime = panelText.pipe(cmd)
                                
                                return currTime
                            end
                            
                            
                            -- get the entire song name (title and artist)
                            panelMusic.song = function()
                                local output = ""
                                local mocpRun = panelText.subGetScript("pgrep -c mocp") + 0
                                
                                if mocpRun == 1 then
                                    local title = panelMusic.title()
                                    local totalTime = panelMusic.totalTime()
                                    local currTime = panelMusic.currTime()
                                    
                                    output = title .. "   " .. currTime .. "/" .. totalTime .. "  " 
                                end
                                
                                return output
                            end
                            
                            
                            -- music player widget (image and text)
                            panelMusic.music = function()
                                myMusic = wibox.widget.textbox()
                                myMusicImage = wibox.widget.imagebox()
                                
                                song = panelMusic.song()
                                
                                panelText.getPipeScript(myMusic, song, "")
                                panelMusic.getIcon(myMusicImage)
                                
                                return myMusicImage, myMusic
                            end
                            
                        end
                       )