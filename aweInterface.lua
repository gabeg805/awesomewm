-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     aweInterface
-- 
-- 
-- Syntax: 
-- 	
--     dofile("/PATH/TO/FILE/aweInterface.lua")
-- 
-- 
-- Purpose:
-- 	
--     Sets up customized Awesome panel, layout, background, etc.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     N/A
-- 
-- 
-- Dependencies:
--
--     gears     - Awesome builtin module
--     awful     - Awesome builtin module
--     wibox     - Awesome builtin module
--     beautiful - Awesome builtin module
--     naughty   - Awesome builtin module
--     menubar   - Awesome builtin module
-- 
--     gabegWidgets - custom module, adds widgets to panel
--   
--   
--  File Structure:
--
--     * Import Libraries
--     * Set the Awesome Layout
--     * Define the Panel Widgets
--     * Define Panel Icons
--     * Initialize Panel Items
--     * Complete The Panel
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 08 2014 <> created
--
-- ************************************************************************



-- ****************
-- IMPORT LIBRARIES
-- ****************

local gabegWidgets = require("gabegWidgets")
                               


-- **********************
-- SET THE AWESOME LAYOUT
-- **********************

gabegWidgets.wallpaper()
layouts = gabegWidgets.layouts()



-- ************************
-- DEFINE THE PANEL WIDGETS
-- ************************

-- create Awesome menu widget
myLauncher = gabegWidgets.aweMenu()

-- create Awesome text clock widget
myTextClockImage, myTextClock = gabegWidgets.clock()

-- define battery, wifi, and volume widgets
myBatteryImage, myBatteryTextBox = gabegWidgets.battery()
myWirelessImage = gabegWidgets.wireless()
myVolumeImage = gabegWidgets.volume()
myBrightnessImage = gabegWidgets.brightness()

-- enable the widget timer
gabegWidgets.setTimer( myBatteryImage, myBatteryTextBox, myWirelessImage, myVolumeImage, 60)


-- -- set the music player popup
-- -- * SEE "panelMusic.lua" for why the code below is commented/uncommented
-- gabegWidgets.music(5)




-- ******************
-- DEFINE PANEL ICONS
-- ******************

arr0 = wibox.widget.imagebox()
arr1 = wibox.widget.imagebox()
arr2 = wibox.widget.imagebox()
arr3 = wibox.widget.imagebox()
arrEnd = wibox.widget.imagebox()

arr0:set_image("/home/gabeg/.config/awesome/icons/powerarrow/arr0.png")
arr1:set_image("/home/gabeg/.config/awesome/icons/powerarrow/arr1.png")
arr2:set_image("/home/gabeg/.config/awesome/icons/powerarrow/arr2.png")
arr3:set_image("/home/gabeg/.config/awesome/icons/powerarrow/arr3.png")
arrEnd:set_image("/home/gabeg/.config/awesome/icons/powerarrow/arrEnd.png")



-- **********************
-- INITIALIZE PANEL ITEMS
-- **********************

myTaskBar = {}
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}

mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag)
                                         )

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
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
                         end),
    awful.button({ }, 3, function ()
                     if instance then
                         instance:hide()
                         instance = nil
                     else
                         instance = awful.menu.clients({ width=250 })
                     end
                         end))


-- ******************
-- COMPLETE THE PANEL
-- ******************

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
    myTaskBar[s] = awful.wibox({ position = "bottom", screen = s })
    

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mypromptbox[s])
    left_layout:add(myLauncher)
    -- left_layout:add(mylayoutbox[s])    
    left_layout:add(mytaglist[s])

    
    
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end

    -- right_music:add(myMusicImage)
    -- right_music:add(myMusicTextBox)
    
    right_layout:add(arrEnd)
    right_layout:add(myBrightnessImage)
    right_layout:add(arr3)
    right_layout:add(myVolumeImage)    
    right_layout:add(arr2)
    right_layout:add(myWirelessImage)
    right_layout:add(arr1)
    right_layout:add(myBatteryImage)
    right_layout:add(myBatteryTextBox) 
    right_layout:add(arr0)
    right_layout:add(myTextClockImage)
    right_layout:add(myTextClock)

    -- right_layout:add(myLauncher)
    right_layout:add(mylayoutbox[s])        
    
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    
    mywibox[s]:set_widget(layout)
    myTaskBar[s]:set_widget(mytasklist[s])
end


