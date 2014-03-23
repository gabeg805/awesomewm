-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     panelClock
-- 
-- 
-- Syntax: 
-- 	
--     panelClock = require("panelClock")
-- 
-- 
-- Purpose:
-- 	
--     Returns the clock widget so that the user can put it on the panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     disp_cal         - display the calendar as a popup
--     add_calendar     - displays the click-enabled calendar
--     panelClock.hover - enables mouse event with the scroll wheel to change
--                        the month
--     panelClock.clock - returns the clock widget 
-- 
-- 
-- Dependencies:
--
--     awful   - Awesome builtin module
--     naughty - Awesome builtin module
--     wibox   - Awesome builtin module
--   
--   
--  File Structure:
--
--     * Define Necessary Variables
--     * Define the Module
--     * Create the Awesome Launcher
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



-- **************************
-- DEFINE NECESSARY VARIABLES
-- **************************

-- icon for clock widget
local clockIcon = "/home/gabeg/.config/awesome/icons/clock.png"



-- *****************
-- DEFINE THE MODULE
-- *****************

function make_module(name, definer)
    local module = {}
    definer(module)
    package.loaded[name] = module
    return module
end




-- *********************
-- CREATE THE TEXT CLOCK
-- *********************

panelClock = make_module('panelClock',
                         function(panelClock)
                             
                             -- display the calendar
                             function disp_cal(val)
                                 naughty.destroy(calendar)
                                 
                                 local cal = awful.util.pread("cal -s " .. val)
                                 calendar = naughty.notify( { text = cal,
                                                              font = "Inconsolata 10", 
                                                              timeout = 0, hover_timeout = 0
                                                            } )
                             end
                             
                             -- enable month switching via scroll wheel
                             panelClock.hover = function(mytextclockImage, mytextclock)
                                 local offset = 0
                                 
                                 -- add the calendar
                                 function add_calendar(inc_offset)
                                     local save_offset = offset
                                     offset = save_offset + inc_offset
                                     
                                     
                                     local datespec = os.date("*t")
                                     datespec = datespec.year * 12 + datespec.month - 1 + offset
                                     datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
                                     
                                     disp_cal(datespec)
                                 end
                                 
                                                                  
                                 -- enable mouse events for textclock widget
                                 mytextclock:buttons( awful.util.table.join( 
                                                          awful.button({ }, 4, function() add_calendar(-1) end),
                                                          awful.button({ }, 5, function() add_calendar(1)  end) )
                                                    )
                                 
                                 mytextclockImage:buttons( awful.util.table.join( 
                                                               awful.button({ }, 4, function() add_calendar(-1) end),
                                                               awful.button({ }, 5, function() add_calendar(1)  end) )
                                                         )                                 
                             end
                             
                             
                             
                             -- returns the clock widget 
                             panelClock.clock = function()
                                 -- create the textclock widget
                                 mytextclockImage = wibox.widget.imagebox()
                                 mytextclockImage:set_image(clockIcon)
                                 
                                 mytextclock = awful.widget.textclock(
                                     '<span background="#777E76" font="Iconsolata 10" color="#EEEEEE"> ' ..
                                         '%a %b %d  %I:%M %p ' ..
                                         '</span>'
                                                                     )
                                 
                                 mytextclock:connect_signal("mouse::enter", function() panelClock.hover(mytextclockImage, mytextclock); disp_cal("")  end)
                                 mytextclock:connect_signal("mouse::leave", function() naughty.destroy(calendar) end)
                                 
                                 return mytextclockImage, mytextclock 
                             end
                         end
                        )