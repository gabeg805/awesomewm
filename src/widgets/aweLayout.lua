-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     aweLayout
-- 
-- 
-- Syntax: 
-- 	
--     require("aweLayout")
-- 
-- 
-- Purpose:
-- 	
--     Gives the user the ability to set the wallpaper, layouts, and tags that the 
--     Awesome WM uses.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     setWallpaper - set the wallpaper for each screen
--     getLayouts   - return the Awesome layout tiling algorithms
--     setTags      - sets the tags and layouts for each screen
-- 
-- 
--  File Structure:
--
--     * Set the Wallpaper
--     * Awesome Tiling Layouts
--     * Awesome Tags
--     * Get the Taglist
--     * Get the Tasklist
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
-- 
--     gabeg Jul 26 2014 <> updating functions to make program easier to use
--
-- **********************************************************************************


-- -----------------
-- SET THE WALLPAPER
-- -----------------

-- Set the Awesome wallpaper
function setWallpaper(wallpaper)
    
    -- Themes define colours, icons, and wallpapers
    beautiful.init("/home/gabeg/.config/awesome/themes/theme.lua")
        
    -- Put the wallpaper on each screen
    for s = 1, screen.count() do
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end



-- ----------------------
-- AWESOME TILING LAYOUTS
-- ----------------------

-- Define Awesome tiling layouts (algorithms)
function setLayouts()
    layouts = {
        awful.layout.suit.fair,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.tile,
        awful.layout.suit.floating    
    }
    
    return layouts
end


-- ------------
-- AWESOME TAGS
-- ------------

-- Define Awesome tags
function setTags(labels, layouts)
    
    -- Add screen tags to workspaces
    tags = { names = labels }
    
    
    -- Each screen has its own tag table.
    for s = 1, screen.count() do
        tags[s] = awful.tag(tags.names, s, layouts[1])
    end
    
    return tags
end



-- ---------------
-- GET THE TAGLIST
-- ---------------

-- Returns the taglist
function getTagList() 
    mytaglist = {}
    
    mytaglist.buttons = awful.util.table.join(
        awful.button({ }, 1, awful.tag.viewonly),
        awful.button({ modkey }, 1, awful.client.movetotag),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, awful.client.toggletag)
                                             )
    
    return mytaglist
end



-- ---------------
-- GET THE TAGLIST
-- ---------------

-- Returns the tasklist
function getTaskList()
    mytasklist = {}
    
    mytasklist.buttons = awful.util.table.join(
        awful.button({ }, 1, 
                     function (c)
                         if c == client.focus then
                             c.minimized = true
                         else
                             -- Without this, the following
                             -- :isvisible() makes no sense
                             c.minimized = false
                             if not c:isvisible() then
                                 awful.tag.viewonly(c:tags()[1])
                             end
                             -- This will also un-minimize
                             -- the client, if needed
                             client.focus = c
                             c:raise()
                         end
                     end
                    ),
        awful.button({ }, 3, 
                     function (c)
                         if instance then
                             instance:hide()
                             instance = nil
                         else
                             instance = awful.menu.clients( { theme = {width = 300, height = 30} } )
                         end
                     end
                    ) )
    
    return mytasklist
end
