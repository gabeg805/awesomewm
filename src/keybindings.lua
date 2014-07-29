-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     keybindings
-- 
-- 
-- Syntax: 
-- 	
--     dofile("/PATH/TO/FILE/keybindings.lua")
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
--  File Structure:
--
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
-- **********************************************************************************


-- --------------------------
-- DEFINE NECESSARY VARIABLES
-- --------------------------

-- define mod key
modkey = "Mod4"



-- --------------
-- MOUSE BINDINGS
-- --------------

-- Mouse bindings
root.buttons(awful.util.table.join(
                 awful.button({ }, 1, function () myMainMenu:hide(); myMusicMenu:hide() end), 
                 awful.button({ }, 3, function () myMainMenu:toggle() end)
                                  )
            )



-- ------------
-- KEY BINDINGS
-- ------------

-- Key bindings
globalkeys = awful.util.table.join(



    -- -----------
    -- SYSTEM KEYS
    -- -----------
    
    -- Brightness keys
    awful.key({ }, "XF86MonBrightnessUp", 
              function() 
                  
                  -- Brightness commands
                  local upBright_cmd = "/home/gabeg/.config/awesome/other/scripts/comp bright inc"
                  
                  -- Change the brightness
                  os.execute(upBright_cmd .. " " .. "5") 
                  
                  -- Display the brightness
                  disp_brightMenu(1, 0)
                  setBrightIcon(myBrightnessImage)
              end
             ),
    
    awful.key({ }, "XF86MonBrightnessDown", 
              function ()

                  -- Brightness commands
                  local downBright_cmd = "/home/gabeg/.config/awesome/other/scripts/comp bright dec"
                  
                  -- Change the brightness
                  os.execute(downBright_cmd .. " " .. "5") 
                  
                  -- Display the brightness
                  disp_brightMenu(1, 0)
                  setBrightIcon(myBrightnessImage)
              end
             ),


    -- Sound Keys
    awful.key({ }, "XF86AudioMute", 
              function() 
                  awful.util.spawn("amixer -c 0 set Master toggle") 
                  disp_volMenu(1, 0)
                  setVolIcon(myVolumeLauncher)
              end),
    awful.key({ }, "XF86AudioRaiseVolume", 
              function() 
                  awful.util.spawn("amixer -c 0 set Master 5+ unmute") 
                  disp_volMenu(1, 0)
                  setVolIcon(myVolumeLauncher)
              end),
    awful.key({ }, "XF86AudioLowerVolume", 
              function()
                  awful.util.spawn("amixer -c 0 set Master 5- unmute") 
                  disp_volMenu(1, 0)
                  setVolIcon(myVolumeLauncher)
              end),
    
    
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("mocp -f") end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("mocp -G") end),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("mocp -r") end),
    
    awful.key({ }, "Print", 
              function () 
                  awful.util.spawn("scrot /home/gabeg/.screen/screenshot.png")
                  os.execute("sleep 0.5")
                  naughty.notify( { text = "Screen Captured!", timeout = 1 } )
              end
             ),
    
    
    
    -- -----------------------------
    -- DOCUMENT LAYOUT MANIPULATIONS
    -- -----------------------------
    
    -- Change layout algorithm
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),    
    
    awful.key({ modkey }, "t", function () mywiboxtasks[mouse.screen].visible = not mywiboxtasks[mouse.screen].visible end),
    
    
    -- --------------------------
    -- DOCUMENT WINDOW MANAGEMENT
    -- --------------------------
    
    -- Client window location
    awful.key({ modkey, "Control" }, "j", function () awful.client.swap.byidx( 1) end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(-1) end),
    
    
    -- Change focus
    awful.key({ modkey,           }, "j",
              function ()
                  awful.client.focus.byidx( 1)
                  if client.focus then client.focus:raise() end
              end),
    
    
    awful.key({ modkey,           }, "k",
              function ()
                  awful.client.focus.byidx(-1)
                  if client.focus then client.focus:raise() end
              end),

    awful.key({ modkey,           }, "Tab",
              function ()
                  awful.client.focus.history.previous()
                  if client.focus then
                      client.focus:raise()
                  end
              end),
    
    
    -- Change length of window
    awful.key({ modkey,           }, "l", function () awful.tag.incmwfact( 0.01)    end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incmwfact(-0.01)    end),
    
    
    -- Restore Minimized Client
    awful.key({ modkey, "Control" }, "m", awful.client.restore),
    
    
    
    -- ------------------------------
    -- DOCUMENT AWESOME MAIN COMMANDS
    -- ------------------------------
    
    -- Open Terminal
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),

    
    -- Restart/Quit Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control"   }, "q", awesome.quit),
    
    
    -- Change Workspace 
    awful.key({ modkey,           }, "Left",  awful.tag.viewprev),
    awful.key({ modkey,           }, "Right", awful.tag.viewnext),

    
    -- Run Firefox
    awful.key({ modkey,           },  "f", function() awful.util.spawn("nice -n 10" .. " " .. browser) end),

    
    -- Prompt (run: PROGRAM)
    awful.key({ modkey },  "r", function () mypromptbox[mouse.screen]:run() end)
       
                                  )



-- -----------
-- CLIENT KEYS
-- -----------

-- Make window Fullscreen AND Kill Focused Process
clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "f",  function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",  function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "f",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Shift"   }, "m",  function (c) c.minimized = true               end),
    awful.key({ modkey,           }, "u",
              function (c)
                  c.maximized_horizontal = not c.maximized_horizontal
                  c.maximized_vertical   = not c.maximized_vertical
              end)
                                  )



-- -----------------------
-- BIND WORKSPACES TO KEYS
-- -----------------------

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
                                       
                                       awful.key({ modkey, "Shift" }, "#" .. i + 9,
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



-- ------------------
-- SET KEYS AND RULES
-- ------------------

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
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons } },
    
    { rule = { }, properties = { }, callback = awful.client.setslave },
    
    -- Set Firefox to always map on tag number 1 of screen 3.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    -- { rule = { class = "Qpdfview" },
    --   properties = { tag = tags[1][4] } },
}



-- --------------
-- CLIENT SIGNALS
-- --------------

-- Signal function to execute when a new client appears.
client.connect_signal("manage", 
                      function (c, startup)
                          
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
