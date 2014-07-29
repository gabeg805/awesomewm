-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     wifi
-- 
-- 
-- Syntax: 
-- 	
--     require("wifi")
-- 
-- 
-- Purpose:
-- 	
--     Returns the wifi widget so that the user can put it on the panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     setWifiIcon   - returns the correct wifi icon given the current wifi 
--                     percentage value
--     disp_wireMenu - displays the mouse hover enabled popup
--     add_wireMenu  - enables the popup
--     wifiHover     - makes wifi widget hoverable and displays computer 
--                     information on popup
--     wifi          - returns the wifi widget
-- 
-- 
--  File Structure:
--
--     * Get Wifi Icon
--     * Wifi Widget Mouse Hover
--     * Create the Wifi Widget
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
-- **********************************************************************************


-- -------------
-- GET WIFI ICON
-- -------------

-- Set the icon for the wifi widget
function setWifiIcon(panel)
    
    -- Wireless network commands
    local mainDir = "/home/gabeg/.config/awesome/other/scripts/"
    local net_cmd = mainDir .. "comp net"
    local ssid_cmd = mainDir .. "comp net ssid"
    

    -- All wifi icons for different percentage values
    local wireNone = "/home/gabeg/.config/awesome/icons/wifi/wireNone.png"
    local wire0 = "/home/gabeg/.config/awesome/icons/wifi/wire0-20.png"
    local wire20 = "/home/gabeg/.config/awesome/icons/wifi/wire20-40.png"
    local wire40 = "/home/gabeg/.config/awesome/icons/wifi/wire40-60.png"
    local wire60 = "/home/gabeg/.config/awesome/icons/wifi/wire60-80.png"
    local wire80 = "/home/gabeg/.config/awesome/icons/wifi/wire80-100.png" 
    
    
    -- Determine wifi signal strength
    local percent = doCommand(net_cmd)
    local subPercent = percent:gsub('%%', '') 
    local subStatus = string.sub(percent, 0, 1)
    local icon = nil
    
    
    -- Check for lack of wifi connection
    if subStatus == "S" then 
        icon = wireNone
    else
        
        -- Various wifi icons
        subPercent = subPercent + 0
        
        if subPercent > 0 and subPercent < 20 then
            icon = wire0
        elseif subPercent >= 20 and subPercent < 40 then
            icon = wire20
        elseif subPercent >= 40 and subPercent < 60 then
            icon = wire40
        elseif subPercent >= 60 and subPercent < 80 then
            icon = wire60
        elseif subPercent >= 80 then
            icon = wire80
        end
    end
    
    panel:set_image(icon)
end



-- -----------------------
-- WIFI WIDGET MOUSE HOVER
-- -----------------------

-- Make wifi widget hoverable (displays popup)
function wifiHover(myWifiImage)
    
    -- Wireless network commands
    local mainDir = "/home/gabeg/.config/awesome/other/scripts/"    
    local net_cmd = mainDir .. "comp net"
    local ssid_cmd = mainDir .. "comp net ssid"
    
    
    -- Kill old wifi notification
    naughty.destroy(wireMenu)
    
    -- Computer info to display on popup
    local netData  = doCommand(net_cmd)
    local ssidData = doCommand(ssid_cmd)
    
    
    -- Compile all the data together
    local wifiDispData = string.format('<span font_desc="Inconsolata 9">%s</span>', 
                                      ssidData .. "\nStrength: " .. netData
                                     )

    -- Display Wifi notification
    wireMenu = naughty.notify( { text = wifiDispData,
                                 font = "Inconsolata 9", 
                                 timeout = 0, hover_timeout = 0
                               } )
    
    
    -- Enable mouse events for textclock widget
    myWifiImage:buttons( awful.util.table.join( 
                                 awful.button({ }, 1, function () wifiHover(myWifiImage) end) ) 
                           )
    
    
    -- Change wifi icon based on network signal shown
    setWifiIcon(myWifiImage)
end



-- ----------------------
-- CREATE THE WIFI WIDGET
-- ----------------------

-- Returns the wifi widget (image and text)
function wifi()
    
    -- Initialize wifi widget
    myWifiImage = wibox.widget.imagebox()
    
    -- Set widget icon
    setWifiIcon(myWifiImage)
    
    -- Enable mouse events
    myWifiImage:connect_signal("mouse::enter", function() wifiHover(myWifiImage) end)
    myWifiImage:connect_signal("mouse::leave", function() naughty.destroy(wireMenu) end) 
    
    
    -- Return wifi widget
    return myWifiImage
end
