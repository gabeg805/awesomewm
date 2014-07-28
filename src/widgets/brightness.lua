-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     brightness
-- 
-- 
-- Syntax: 
-- 	
--     require("brightness")
-- 
-- 
-- Purpose:
-- 	
--     Returns the brightness widget so that the user can put it on the panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     setBrightIcon   - get brightness widget icon
--     disp_brightMenu - display brightness notification
--     brightHover     - make brightness widget display notification on mouse hover
--     add_brightMenu  - increase/decrease the brightness and display the new value
--     brightness      - returns the brightness widget
--   
--   
--  File Structure:
--
--     * Set Brightness Icon
--     * Display Brightness Notification
--     * Enable Brightness Widget Mouse Hover Event 
--     * Create the Brightness Widget
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
-- ************************************************************************


-- -------------------
-- SET BRIGHTNESS ICON
-- -------------------

-- Sets the icon for the wifi widget
function setBrightIcon(panel)
    
    -- Brightness commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local brightStat_cmd = mainDir .. "comp bright stat"

    
    -- All icons for the brightness widget
    local bright0 = "/home/gabeg/.config/awesome/icons/bright/bright0-10.png"
    local bright10 = "/home/gabeg/.config/awesome/icons/bright/bright10-20.png"
    local bright20 = "/home/gabeg/.config/awesome/icons/bright/bright20-30.png"
    local bright30 = "/home/gabeg/.config/awesome/icons/bright/bright30-40.png"
    local bright40 = "/home/gabeg/.config/awesome/icons/bright/bright40-50.png"
    local bright50 = "/home/gabeg/.config/awesome/icons/bright/bright50-60.png"
    local bright60 = "/home/gabeg/.config/awesome/icons/bright/bright60-70.png"
    local bright70 = "/home/gabeg/.config/awesome/icons/bright/bright70-80.png"
    local bright80 = "/home/gabeg/.config/awesome/icons/bright/bright80-90.png"
    local bright90 = "/home/gabeg/.config/awesome/icons/bright/bright90-100.png"
    
    
    -- Check if a command was given, or a percent value
    local percent = nil
    local subPercent = nil
    
    if val ~= nil then
        percent = val
        subPercent = percent:gsub('%%', '')
    else
        percent = doCommand(brightStat_cmd)
        subPercent = percent:gsub('%%','')
    end
    
    
    -- Check if percent value is valid or not
    local subStatus = nil
    
    if tonumber(subPercent) ~= nil then 
        subPercent = subPercent + 0
    else
        subPercent = 'Calculating...'
        subStatus = "C"
    end
    
    
    -- Initialize icon variable
    local icon = nil
    
    
    -- Icon for unknown brightness
    if subStatus == "C" then 
        icon = bright0
    else
        
        -- Various icons for known brightness values
        if subPercent > 0 and subPercent < 10 then
            icon = bright0
        elseif subPercent >= 10 and subPercent < 20 then
            icon = bright10
        elseif subPercent >= 20 and subPercent < 30 then
            icon = bright20
        elseif subPercent >= 30 and subPercent < 40 then
            icon = bright30
        elseif subPercent >= 40 and subPercent < 50 then
            icon = bright40
        elseif subPercent >= 50 and subPercent < 60 then
            icon = bright50
        elseif subPercent >= 60 and subPercent < 70 then
            icon = bright60
        elseif subPercent >= 70 and subPercent < 80 then
            icon = bright70
        elseif subPercent >= 80 and subPercent < 90 then
            icon = bright80
        elseif subPercent >= 90 and subPercent <= 100 then
            icon = bright90
        end
        
    end
    
    panel:set_image(icon)
end



-- -------------------------------
-- DISPLAY BRIGHTNESS NOTIFICATION
-- -------------------------------

-- Display the brightness notification
function disp_brightMenu(timeout, hover_timeout)
    
    -- Brightness commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local brightStat_cmd = mainDir .. "comp bright stat"
        
    
    -- Kill old notification
    naughty.destroy(brightMenu)
    
    
    -- Define timeout and hover timeout if not set
    if timeout == nil  then timeout = 0 end
    if hover_timeout == nil  then hover_timeout = 0 end
    
    
    -- Display the notification
    local brightData = doCommand(brightStat_cmd)
    brightMenu = naughty.notify( { text = "Brightness: " .. brightData,
                                   font = "Inconsolata 9",  
                                   timeout = timeout, hover_timeout = hover_timeout
                                 } )
end



-- ------------------------------------------
-- ENABLE BRIGHTNESS WIDGET MOUSE HOVER EVENT
-- ------------------------------------------

-- Make brightness widget hoverable (display popup)
function brightHover(myBrightnessImage) 
    
    -- Brightness commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local upBright_cmd = mainDir .. "comp bright inc"
    local downBright_cmd = mainDir .. "comp bright dec"
    
    
    -- Display the brightness notification
    disp_brightMenu()  
    
    -- Increase/Decrease the brightness and display the new brightness
    function add_brightMenu(val)
        
        if val < 0 then
            val = -1 * val
            os.execute(downBright_cmd .. "  " .. val)
        else
            os.execute(upBright_cmd .. "  " .. val)
        end
        
        disp_brightMenu()
    end
    
    
    -- Enable mouse events for widget
    myBrightnessImage:buttons( awful.util.table.join( 
                                   awful.button({ }, 4, function() add_brightMenu(10) end),
                                   awful.button({ }, 5, function() add_brightMenu(-10)  end)
                                                    )
                             )
end



-- ----------------------------
-- CREATE THE BRIGHTNESS WIDGET
-- ----------------------------

-- Returns brightness widget (image and text)
function brightness()
    
    -- Initialize brightness imagebox
    myBrightnessImage = wibox.widget.imagebox()
    
    -- Set widget icon
    setBrightIcon(myBrightnessImage)
    
    
    -- Enable widget mouse events
    myBrightnessImage:connect_signal("mouse::enter", function() brightHover(myBrightnessImage) end)
    myBrightnessImage:connect_signal("mouse::leave", function() naughty.destroy(brightMenu) end)
    
    
    -- Return the brightness widget
    return myBrightnessImage
end
