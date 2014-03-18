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
--     panelClock.clock - returns the clock widget (image and text)
--     remove_calendar  - removes the click-enabled calendar
--     add_calendar     - displays the click-enabled calendar
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
                             
                             
                             -- returns the clock widget (image and text)
                             panelClock.clock = function()
                                 -- create the textclock widget
                                 mytextclockImage = wibox.widget.imagebox()
                                 mytextclockImage:set_image(clockIcon)
                                 
                                 mytextclock = awful.widget.textclock(
                                     '<span background="#777E76" font="Iconsolata 10" color="#EEEEEE"> ' ..
                                         '%a %b %d  %I:%M %p ' ..
                                         '</span>'
                                                                     )
                                 
                                 
                                 -- enable a clickable calendar
                                 local calendar = nil
                                 local offset = 0
                                 
                                 
                                 -- remove the calendar
                                 function remove_calendar()
                                     if calendar ~= nil then
                                         naughty.destroy(calendar)
                                         calendar = nil
                                         offset = 0
                                     end
                                 end
                                 
                                 
                                 -- add the calendar
                                 function add_calendar(inc_offset)
                                     local save_offset = offset
                                     
                                     remove_calendar()
                                     
                                     offset = save_offset + inc_offset
                                     
                                     
                                     local datespec = os.date("*t")
                                     datespec = datespec.year * 12 + datespec.month - 1 + offset
                                     datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
                                     
                                     
                                     local cal = awful.util.pread("cal -s " .. datespec)
                                     cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
                                     calendar = naughty.notify( { text = string.format('<span font_desc="%s">%s</span>', 
                                                                                       "Inconsolata 10", cal),
                                                                  timeout = 0, hover_timeout = 1,
                                                                  width = 160,
                                                                  height = 150,
                                                                } )
                                 end
                                 
                                 
                                 
                                 -- enable mouse events for textclock widget
                                 mytextclock:buttons( awful.util.table.join( 
                                                          awful.button({ }, 1, function () add_calendar(0) end),
                                                          awful.button({ }, 4, function() add_calendar(-1) end),
                                                          awful.button({ }, 5, function() add_calendar(1)  end)
                                                                           )
                                                    )

                                 return mytextclockImage, mytextclock 
                             end
                         end
                        )