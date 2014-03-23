-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     aweBindings
-- 
-- 
-- Syntax: 
-- 	
--     dofile("/PATH/TO/FILE/aweBindings.lua")
-- 
-- 
-- Purpose:
-- 	
--     Defines mouse and keybindings, and client rules.
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
--     awful     - Awesome builtin module
--     beautiful - Awesome builtin module
--    
--    
--  File Structure:
--
--     * Import Modules
--     * Mouse Bindings
--     * Key Bindings
--     * Client Keys
--     * Bind Worspaces to Keys
--     * Set Keys and Rules
--     * Client Signals
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 08 2014 <> created
--
-- ************************************************************************



-- **************
-- IMPORT MODULES
-- **************

local bindFuncs = require("bindFuncs")



-- **************
-- MOUSE BINDINGS
-- **************

-- Mouse bindings
root.buttons(awful.util.table.join(
                 awful.button({ }, 3, function () mymainmenu:toggle() end),
                 awful.button({ }, 4, awful.tag.viewnext),
                 awful.button({ }, 5, awful.tag.viewprev)
                                  )
            )



-- ************
-- KEY BINDINGS
-- ************

-- define mod key
modkey = "Mod4"

-- make the taskbar initially invisible (there's a macro to make it visible below)
myTaskBar[mouse.screen].visible = not myTaskBar[mouse.screen].visible


-- Key bindings
globalkeys = awful.util.table.join(
    
    -- Restore Minimized Client
    awful.key({ modkey, "Control" }, "m", awful.client.restore),
    
    -- Toggle Panel Visibility
    awful.key({ modkey }, "t", function ()
                  myTaskBar[mouse.screen].visible = not myTaskBar[mouse.screen].visible
                               end),    
    
    -- Change Viewport 
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    
    -- Change focus
    awful.key({ modkey,           }, "j",
              function ()
                  awful.client.focus.byidx( 1)
                  if client.focus then client.focus:raise() end
              end
             ),
    
    
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey,           }, "Tab",
              function ()
                  awful.client.focus.history.previous()
                  if client.focus then
                      client.focus:raise()
                  end
              end
             ),
    
    
    -- Open Terminal and Restart/Quit Awesome
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    
    -- Change length of window
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "k",     function () awful.tag.incmwfact(-0.05)    end),
    
    -- change layout algorithm
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    
    
    -- Prompt (run: PROGRAM)
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    
    
    -- brightness keys
    awful.key({ }, "XF86MonBrightnessUp", function() bindFuncs.signalBright("up") end),
    awful.key({ }, "XF86MonBrightnessDown", function () bindFuncs.signalBright("down") end),


    -- Sound Keys
    awful.key({ }, "XF86AudioMute", function() bindFuncs.signalVolume("mute") end),
    awful.key({ }, "XF86AudioRaiseVolume", function() bindFuncs.signalVolume("up") end),
    awful.key({ }, "XF86AudioLowerVolume", function() bindFuncs.signalVolume("down") end),
                  
    
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("mocp -f") end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("mocp -G") end),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("mocp -r") end),
    
    awful.key({ }, "Print", 
              function () 
                  awful.util.spawn("scrot /home/gabeg/screenshot.png") 
                  naughty.notify( { text = "Screen Captured!", timeout = 1 } )
              end
             )
        
                                  )



-- ***********
-- CLIENT KEYS
-- ***********

-- Make window Fullscreen AND Kill Focused Process
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "m",      function (c) c.minimized = true               end),
    awful.key({ modkey,           }, "u",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)

                                  )



-- ***********************
-- BIND WORKSPACES TO KEYS
-- ***********************

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
                                       awful.key({ modkey }, "#" .. i + 9,
                                                 function ()
                                                     local screen = mouse.screen
                                                     local tag = awful.tag.gettags(screen)[i]
                                                     if tag then
                                                         awful.tag.viewonly(tag)
                                                     end
                                                 end
                                                ),
                                       
                                       awful.key({ modkey, "Control" }, "#" .. i + 9,
                                                 function ()
                                                     if client.focus then
                                                         local tag = awful.tag.gettags(client.focus.screen)[i]
                                                         if tag then
                                                             awful.client.movetotag(tag)
                                                         end
                                                     end
                                                 end
                                                )
                                      )
end



-- moves window (client) to desired location
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
                                     )



-- ******************
-- SET KEYS AND RULES
-- ******************

-- Set keys
root.keys(globalkeys)


-- Set Rules
awful.rules.rules = {
    
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { }, properties = { }, callback = awful.client.setslave },
    -- Set Firefox to always map on tag number 1 of screen 3.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    -- { rule = { class = "Qpdfview" },
    --   properties = { tag = tags[1][4] } },
}



-- **************
-- CLIENT SIGNALS
-- **************

-- Signal function to execute when a new client appears.
client.connect_signal("manage", 
                      function (c, startup)
                          
                          -- Enable sloppy focus
                          c:connect_signal("mouse::enter", 
                                           function(c)
                                               if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                                   and awful.client.focus.filter(c) then
                                               client.focus = c
                                               end
                                           end
                                          )
                          
                          if not startup then
                              -- Set the windows at the slave,
                              -- i.e. put it at the end of others instead of setting it master.
                              -- awful.client.setslave(c)
                              
                              -- Put windows in a smart way, only if they does not set an initial position.
                              if not c.size_hints.user_position and not c.size_hints.program_position then
                                  awful.placement.no_overlap(c)
                                  awful.placement.no_offscreen(c)
                              end
                          end
                          
                          local titlebars_enabled = false
                          if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
                              -- buttons for the titlebar
                              local buttons = awful.util.table.join(
                                  awful.button({ }, 1, 
                                               function()
                                                   client.focus = c
                                                   c:raise()
                                                   awful.mouse.client.move(c)
                                               end
                                              ),
                                  
                                  awful.button({ }, 3, 
                                               function()
                                                   client.focus = c
                                                   c:raise()
                                                   awful.mouse.client.resize(c)
                                               end
                                              )
                                                                   )
                              
                              -- Widgets that are aligned to the left
                              local left_layout = wibox.layout.fixed.horizontal()
                              left_layout:add(awful.titlebar.widget.iconwidget(c))
                              left_layout:buttons(buttons)
                              
                              -- Widgets that are aligned to the right
                              local right_layout = wibox.layout.fixed.horizontal()
                              right_layout:add(awful.titlebar.widget.floatingbutton(c))
                              right_layout:add(awful.titlebar.widget.maximizedbutton(c))
                              right_layout:add(awful.titlebar.widget.stickybutton(c))
                              right_layout:add(awful.titlebar.widget.ontopbutton(c))
                              right_layout:add(awful.titlebar.widget.closebutton(c))
                              
                              -- The title goes in the middle
                              local middle_layout = wibox.layout.flex.horizontal()
                              local title = awful.titlebar.widget.titlewidget(c)
                              title:set_align("center")
                              middle_layout:add(title)
                              middle_layout:buttons(buttons)
                              
                              -- Now bring it all together
                              local layout = wibox.layout.align.horizontal()
                              layout:set_left(left_layout)
                              layout:set_right(right_layout)
                              layout:set_middle(middle_layout)
                              
                              awful.titlebar(c):set_widget(layout)
                          end
                      end
                     )

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
