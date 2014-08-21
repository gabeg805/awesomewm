-- 
-- CREATED BY: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- NAME:
-- 	
--     aweInterface
-- 
-- 
-- SYNTAX: 
-- 	
--     dofile("/PATH/TO/FILE/aweInterface.lua")
-- 
-- 
-- PURPOSE:
-- 	
--     Sets up customized Awesome panel, layout, background, etc.
-- 
-- 
-- KEYWORDS:
-- 	
--     N/A
-- 
-- 
-- FUNCTIONS:
-- 	
--     N/A
-- 
-- 
--  FILE STRUCTURE:
--
--     * Import Libraries
--     * Define the Panel Widgets
--     * Complete The Panel
-- 
-- 
-- MODIFICATION HISTORY:
-- 	
--     gabeg Mar 08 2014 <> created
--
-- **********************************************************************************



-- ----------------------------
-- ----- IMPORT LIBRARIES -----
-- ----------------------------

require("Clock")
require("Battery")
require("Wifi")
require("Volume")
require("Brightness")



-- ------------------------------------
-- ----- DEFINE THE PANEL WIDGETS -----
-- ------------------------------------

-- Create Awesome text clock widget
myTextClock = clock()

-- Define battery, wifi, and volume widgets
myBatteryImage = battery()
myWifiImage = wifi()
myVolumeImage = volume()
myBrightnessImage = brightness()


-- Enable timer to refresh widgets
mytimer = timer({ timeout = 60 })
mytimer:connect_signal("timeout", 
                       function()
                           batWarning()
                           setBatIcon(myBatteryImage)
                           setWifiIcon(myWifiImage)
                           setVolIcon(myVolumeImage)
                       end
                      )
mytimer:start()


-- ------------------------------
-- ----- COMPLETE THE PANEL -----
-- ------------------------------

mywibox = {}
mywiboxtasks = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = getTagList()
mytasklist = getTaskList()

for s = 1, screen.count() do


    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                               awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                               awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    
    
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    
    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })    
    mywiboxtasks[s] = awful.wibox({ position = "bottom", screen = s })    
    
    
    -- Widgets that are aligned to the middle
    local middle_layout = wibox.layout.fixed.horizontal()
    middle_layout:add(myTextClock)
    

    local middle_layouttasks = wibox.layout.fixed.horizontal()
    middle_layouttasks:add(mytasklist[s])
    
    
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    
    left_layout:add(mypromptbox[s])
    left_layout:add(mytaglist[s])
    
    
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    
    right_layout:add(myBrightnessImage)
    right_layout:add(myVolumeImage)
    right_layout:add(myWifiImage)
    right_layout:add(myBatteryImage)
    right_layout:add(mylayoutbox[s])
    
    
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    local layouttasks = wibox.layout.align.horizontal()
    
    layout:set_left(left_layout)
    layout:set_middle(middle_layout)
    layout:set_right(right_layout)
    
    mywibox[s]:set_widget(layout)
    
    
    layouttasks:set_middle(middle_layouttasks)
    mywiboxtasks[s]:set_widget(layouttasks)
end
