-- 
-- CREATED BY: Gabriel Gonzalez (contact me at gabeg@bu.edu)   
-- 
-- 
-- NAME:
-- 	
--     Clock
-- 
-- 
-- SYNTAX: 
-- 	
--     require("Clock")
-- 
-- 
-- PURPOSE:
-- 	
--     Returns the clock widget so that the user can put it on the panel.
-- 
-- 
-- KEYWORDS:
-- 	
--     N/A
-- 
-- 
-- FUNCTIONS:
-- 	
--     disp_cal     - display the calendar as a popup
--     add_calendar - displays the click-enabled calendar
--     clockHover   - enables mouse event with the scroll wheel to change the month
--     clock        - returns the clock widget 
-- 
-- 
--  FILE STRUCTURE:
--
--     * Display Clock Calendar
--     * Enable Clock Widget Mouse Hover Event
--     * Create the Text Clock
-- 
-- 
-- MODIFICATION HISTORY:
-- 	
--     gabeg Mar 13 2014 <> created
-- 
--     gabeg Mar 22 2014 <> removed widget text that would appear on the panel and 
--                          made it instead display in a popup. also made the popup
--                          appear when mouse hovers over the widget
-- 
--     gabeg Mar 13 2014 <> updated the program so that it's easier to use
--
-- **********************************************************************************


-- ----------------------------------
-- ----- DISPLAY CLOCK CALENDAR -----
-- ----------------------------------

-- Display the calendar
function disp_cal(val)
    naughty.destroy(calendar)
    if val == nil then val = '' end
    
    local cal = awful.util.pread("cal -s " .. val)
    calendar = naughty.notify( { text = cal,
                                 font = "Inconsolata 9",
                                 position = "top_left",
                                 timeout = 0, hover_timeout = 0
                               } )
end



-- -------------------------------------------------
-- ----- ENABLE CLOCK WIDGET MOUSE HOVER EVENT -----
-- -------------------------------------------------

-- Enable hover mouse events 
function clockHover(mytextclock)
    
    -- Display the calendar
    disp_cal()  
    
    
    -- Create new calendar (for scrollwheel switching)
    local offset = 0
    function add_calendar(inc_offset)
        local save_offset = offset
        offset = save_offset + inc_offset
        
        
        local datespec = os.date("*t")
        datespec = datespec.year * 12 + datespec.month - 1 + offset
        datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
        
        disp_cal(datespec)
    end
    
    
    -- Enable mouse events for textclock widget
    mytextclock:buttons( awful.util.table.join( 
                             awful.button({ }, 4, function() add_calendar(-1) end),
                             awful.button({ }, 5, function() add_calendar(1)  end) )
                       )    
end



-- ---------------------------------
-- ----- CREATE THE TEXT CLOCK -----
-- ---------------------------------

-- Returns the clock widget 
function clock()
    
    -- Define clock setup
    local spaces = '        '
    mytextclock = awful.widget.textclock(
        '<span font="Inconsolata 8" color="#FFFFFF"> ' ..
            spaces .. '%a %b %d, %I:%M %p </span>')
    
    
    -- Enable textclock mouse events
    mytextclock:connect_signal("mouse::enter", function() clockHover(mytextclock) end)
    mytextclock:connect_signal("mouse::leave", function() naughty.destroy(calendar) end)
    
    
    -- Return the clock widget
    return mytextclock 
end
