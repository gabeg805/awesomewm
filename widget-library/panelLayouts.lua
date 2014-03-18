-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     panelLayouts
-- 
-- 
-- Syntax: 
-- 	
--     panelLayouts = require("panelLayouts")
-- 
-- 
-- Purpose:
-- 	
--     Returns the Awesome layouts and set the wallpaper for each screen.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     panelLayouts.wallpaper - set the wallpaper for each screen
--     panelLayouts.layouts   - return the Awesome layout tiling algorithms
-- 
-- 
-- Dependencies:
--
--     awful     - Awesome builtin module
--     beautiful - Awesome builtin module
--     gears     - Awesome builtin module
--     menubar   - Awesome builtin module
--   
--   
--  File Structure:
--
--     * Define the Module
--     * Define the Awesome Layout
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
--
-- ************************************************************************



-- *****************
-- DEFINE THE MODULE
-- *****************
 
function make_module(name, definer)
   local module = {}
   definer(module)
   package.loaded[name] = module
   return module
end
 


-- *************************
-- DEFINE THE AWESOME LAYOUT
-- *************************

panelLayouts = make_module('panelLayouts',
                           function(panelLayouts)
                               
                               -- set the wallpaper
                               panelLayouts.wallpaper = function()
                                   
                                   -- themes define colours, icons, and wallpapers
                                   beautiful.init("/usr/share/awesome/themes/default/theme.lua")
                                   astroWallpaper = "/mnt/Linux/Share/docs/pics/Sugarpine.jpg"
                                   
                                   
                                   -- put the wallpaper on each screen
                                   if beautiful.wallpaper then
                                       for s = 1, screen.count() do
                                           -- gears.wallpaper.maximized(beautiful.wallpaper, s, true)
                                           gears.wallpaper.maximized(astroWallpaper, s, true)
                                       end
                                   end
                               end
                               
                               
                               
                               -- define awesome tiling layouts (algorithms)
                               panelLayouts.layouts = function()
                                   local layouts = {
                                       awful.layout.suit.tile,
                                       awful.layout.suit.tile.left,
                                       
                                       awful.layout.suit.tile.bottom,
                                       awful.layout.suit.tile.top,
                                       
                                       awful.layout.suit.fair,
                                       
                                       awful.layout.suit.max,
                                       awful.layout.suit.magnifier,
                                       awful.layout.suit.floating
                                   }
                                   
                                   
                                   -- add screen tags to workspaces
                                   tags = { names = { "1", "2", "3", "4", "5" } }
                                   
                                   
                                   -- Each screen has its own tag table.
                                   for s = 1, screen.count() do
                                       tags[s] = awful.tag(tags.names, s, layouts[1])
                                   end
                                   
                                   -- Menubar configuration, Set the terminal for applications that require it
                                   menubar.utils.terminal = "urxvt"
                                   
                                   return layouts
                               end
                               
                           end
                          )