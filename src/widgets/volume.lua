-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     volume
-- 
-- 
-- Syntax: 
-- 	
--     require("volume")
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
--     muteStat       - check if mute is toggled
--     musicStat      - check if MOCP (the music player) is running
--     getSong        - returns the song title and artist
--     getVolIcon     - returns icon path
--     setVolIcon     - set the volume widget icon
--     disp_musicMenu - enables the music popup
--     disp_volMenu   - enables the volume popup
--     volHover       - makes the volume widget hoverable
--     add_volMenu    - displays the hover-enabled popup
--     volume         - returns the volume widget 
-- 
-- 
-- File Structure:
--
--     * Import Modules 
--     * Status Functions
--     * Retrieval Functions
--     * Set Volume Icon
--     * Menu Display Functions
--     * Enable Volume Widget Mouse Hover Event
--     * Create the Volume Widget
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
-- 
--     gabeg Mar 22 2014 <> removed widget text that would appear on the panel and
--                          made it instead display in a popup. also made the popup
--                          appear when mouse hovers over the widget instead of
--                          by clicking
-- 
--     gabeg Jul 26 2014 <> updating functions to make program easier to use
--
-- **********************************************************************************



-- **************
-- IMPORT MODULES
-- **************

require("commandline")


-- ----------------------------
-- ----- STATUS FUNCTIONS -----
-- ----------------------------

-- Check if mute is toggled
function muteStat()
    
    -- Volume commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local volMuteStat_cmd = mainDir .. "comp vol muteStat"
    
    
    -- Check if volume is muted
    local status = doCommand(volMuteStat_cmd)
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



-- Check if music is playing
function musicStat()
    
    -- Volume commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local musicRunStat_cmd = "pgrep -c mocp"
    
    
    -- Check status of music player
    local status = doCommand(musicRunStat_cmd) + 0
    
    if status > 0 then
        musicTest = "music"
    else
        musicTest = "nomusic"
    end
    
    return musicTest
end



-- -------------------------------
-- ----- RETRIEVAL FUNCTIONS -----
-- -------------------------------

-- Return the entire song name (title and artist)
function getSong()
    
    -- Get music information from MOCP
    local title_cmd = "mocp -i | grep -m 1 -E '^Title' | cut -f2 -d':' | sed 's/^[ \t]*//'"
    local totalTime_cmd = "mocp -i | grep -m 1 TotalTime | cut -f2 -d' '"
    local currTime_cmd = "mocp -i | grep -m 1 CurrentTime | cut -f2 -d' '"
    
    -- Title, total time, and current time of song
    local title = doCommand(title_cmd)
    local totalTime = doCommand(totalTime_cmd)
    local currTime = doCommand(currTime_cmd)
        
    -- Piece it together
    local output = title .. "   " .. currTime .. "/" .. totalTime .. "  " 
    local outputBare = "   /  "
    
    -- Check song output
    if title == nil or currTime == nil or totalTime == nil or output == outputBare then 
        return nil
    end
    
    return output
end



-- Return icon path
function getVolIcon()
    
    -- Volume commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local vol_cmd = mainDir .. "comp vol stat"
        
    
    -- All volume icons for different percentage values
    local volMute = "/home/gabeg/.config/awesome/icons/vol/volMute.png"
    local vol0 = "/home/gabeg/.config/awesome/icons/vol/vol0-20.png"
    local vol20 = "/home/gabeg/.config/awesome/icons/vol/vol20-40.png"
    local vol40 = "/home/gabeg/.config/awesome/icons/vol/vol40-60.png"
    local vol60 = "/home/gabeg/.config/awesome/icons/vol/vol60-80.png"
    local vol80 = "/home/gabeg/.config/awesome/icons/vol/vol80-100.png"
    
    -- All volume icons when music is playing
    local volMusMute = "/home/gabeg/.config/awesome/icons/vol/volMusMute.png"
    local volMus0 = "/home/gabeg/.config/awesome/icons/vol/volMus0-20.png"
    local volMus20 = "/home/gabeg/.config/awesome/icons/vol/volMus20-40.png"
    local volMus40 = "/home/gabeg/.config/awesome/icons/vol/volMus40-60.png"
    local volMus60 = "/home/gabeg/.config/awesome/icons/vol/volMus60-80.png"
    local volMus80 = "/home/gabeg/.config/awesome/icons/vol/volMus80-100.png"
    
    
    -- Determine volume status
    local percent = doCommand(vol_cmd)
    local subPercent = percent:gsub('%%','') + 0
    local icon = nil
    
    local muteTest = muteStat()
    local musicTest = musicStat()
    
    
    -- Check if music is running
    if musicTest == "music" then
        if muteTest == "mute" or subPercent == 0 then
            icon = volMusMute
        elseif subPercent > 0 and subPercent < 20 then
            icon = volMus0
        elseif subPercent >= 20 and subPercent < 40 then
            icon = volMus20
        elseif subPercent >= 40 and subPercent < 60 then
            icon = volMus40
        elseif subPercent >= 60 and subPercent < 80 then
            icon = volMus60
        elseif subPercent >= 80 then
            icon = volMus80
        end
    else
        
        -- Display non-music icons
        if muteTest == "mute" or subPercent == 0 then
            icon = volMute
        elseif subPercent > 0 and subPercent < 20 then
            icon = vol0
        elseif subPercent >= 20 and subPercent < 40 then
            icon = vol20
        elseif subPercent >= 40 and subPercent < 60 then
            icon = vol40
        elseif subPercent >= 60 and subPercent < 80 then
            icon = vol60
        elseif subPercent >= 80 then
            icon = vol80
        end
    end
    
    return icon
end



-- ---------------
-- SET VOLUME ICON
-- ---------------

-- Set the icon for the volume widget
function setVolIcon(panel)
    local volIcon = getVolIcon()
    panel:set_image(volIcon)
end



-- ----------------------------------
-- ----- MENU DISPLAY FUNCTIONS -----
-- ----------------------------------

-- Display all the music information as a popup
function disp_musicMenu(timeout, hover_timeout)
    
    -- Check for running process of MOCP
    local mocpRun = doCommand("pgrep -c mocp") + 0
    
    -- Kill menu if open
    if songMenu ~= nil then naughty.destroy(songMenu) end 
    
    -- Display music noficiation if music is playing
    if mocpRun > 0 then
        naughty.destroy(songMenu)
        
        song = getSong()
        
        if song == nil then 
            os.execute("pkill mocp")
            naughty.destroy(songMenu)
        else
            
            -- Define notification timeout if not set
            if timeout == nil then timeout = 0 end
            if hover_timeout == nil then hover_timeout = 0 end
            
            songMenu = naughty.notify( { text = song,
                                         font = "Inconsolata 10",
                                         position = "bottom_right",
                                         timeout = timeout, hover_timeout = hover_timeout
                                       } )
        end
    end
end



-- Displays the volume notification
function disp_volMenu(timeout, hover_timeout)
    
    -- Volume commands
    local mainDir = "/mnt/Linux/Share/scripts/"    
    local vol_cmd = mainDir .. "comp vol stat"
    local chVol_cmd = mainDir .. "comp vol"
    
    
    -- Define notification timeout if not set
    if timeout == nil then timeout = 0 end
    if hover_timeout == nil then hover_timeout = 0 end
    
    
    -- Kill old notification bubbles
    naughty.destroy(volMenu)
    
    -- Notification width
    wide = 110
    
    -- Notification volume data
    local volData = doCommand(vol_cmd)
    
    -- Mute test
    local muteTest = muteStat()
    
    if muteTest == "mute" then 
        volData = volData:gsub('%%', '%%  (Muted)')
        wide = 170
    end
    
    
    -- Display the notification
    volMenu = naughty.notify( { text = "Volume: " .. volData, 
                                font = "Inconsolata 10", 
                                timeout = timeout, hover_timeout = hover_timeout,
                                width = wide,
                                height = 30
                              } )
end



-- --------------------------------------------------
-- ----- ENABLE VOLUME WIDGET MOUSE HOVER EVENT -----
-- --------------------------------------------------

-- Make the popup increment volume with scrolling
function volHover(myVolumeLauncher, myMusicMenu) 
    
    -- Volume commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local vol_cmd = mainDir .. "comp vol stat"
    local chVol_cmd = mainDir .. "comp vol"
    
    
    -- Display the volume and music notifications
    disp_volMenu()
    disp_musicMenu()
    
    
    -- Check volume menu status 
    local temp = doCommand(vol_cmd)
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
    
    
    -- Set the volume widget icon
    setVolIcon(myVolumeLauncher)
end



-- ------------------------------------
-- ----- CREATE THE VOLUME WIDGET -----
-- ------------------------------------

-- Returns the volume widget (image and text)
function volume()
    
    -- Music commands
    local musicPause = "mocp -G"
    local musicNextSong = "mocp -f"
    local musicPrevSong = "mocp -r"
    local musicReplay = "mocp -p"
    local musicExit = "mocp -x"
    
    
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
    local volumeIcon = getVolIcon()
    myVolumeLauncher = awful.widget.launcher( { image = volumeIcon, menu = myMusicMenu} )
    
    
    -- Enable mouse events for launcher
    myVolumeLauncher:connect_signal("mouse::enter", function() volHover(myVolumeLauncher, myMusicMenu) end)
    myVolumeLauncher:connect_signal("mouse::leave", function() naughty.destroy(volMenu); naughty.destroy(songMenu) end) 
    
    
    -- Return volume launcher
    return myVolumeLauncher
end
