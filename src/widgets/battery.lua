-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)  
-- 
-- 
-- Name:
-- 	
--     battery
-- 
-- 
-- Syntax: 
-- 	
--     require("battery")
-- 
-- 
-- Purpose:
-- 	
--     Returns the battery widget so that the user can put it on the panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     batWarning   - displays a warning when battery charge is low
--     setBatIcon   - returns the correct battery icon given the current battery 
--                    percentage value
--     disp_batMenu - displays a notification containing battery information
--     disp_sysMenu - displays a notification containing system information
--     batHover     - makes battery widget hoverable, displays computer information 
--                    on popup
--     battery      - returns the battery widget (image and text)
-- 
-- 
--  File Structure:
--
--     * Battery Warning
--     * Set Battery Icon 
--     * Display Battery and System Notification
--     * Enable Battery Widget Mouse Hover Event
--     * Create the Battery Widget 
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
-- 
--     gabeg Mar 22 2014 <> removed widget text that would appear on the 
--                          panel and made it instead display in a popup.
--                          also made the popup appear when mouse hovers
--                          over the widget instead of by clicking
-- 
--     gabeg Jul 26 2014 <> updating functions to make program easier to use
--
-- ************************************************************************


-- ---------------
-- BATTERY WARNING
-- ---------------

-- Display warning if battery charge is too low
function batWarning()

    -- Battery commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local bat_cmd = mainDir .. "comp bat"
    local batStat_cmd = mainDir .. "comp bat stat"
    
    
    -- Determine battery status and charge
    local status = doCommand(batStat_cmd)
    local subStatus = string.sub(status, 0, 1)
    
    local percent = doCommand(bat_cmd)
    local subPercent = percent:gsub('%%','') 
    
    
    if tonumber(subPercent) ~= nil then 
        subPercent = subPercent + 0
    else
        subStatus = "C"
    end
    
    
    -- Shut down computer when charge less than 10%
    if subPercent <= 10 and subStatus ~= "C" then
        os.execute(shuttingDown)
    end
    

    -- Display warning when charge less than 20%
    if subPercent < 20 and subStatus ~= "C" then
        naughty.notify( {
                            preset = naughty.config.presets.critical, 
                            title = "SYSTEM ALERT",
                            text = "Arch Linux will shutdown at 10%.",
                            position = "top_right",
                            font = "Inconsolata 10",
                            timeout = 15, hover_timeout = 0
                        } )
    end
end



-- ----------------
-- SET BATTERY ICON
-- ----------------

-- Set icon for battery widget
function setBatIcon(panel)

    -- Battery commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local bat_cmd = mainDir .. "comp bat"
    local batStat_cmd = mainDir .. "comp bat stat"
    
    -- Main battery icon directory
    local mainBatIcon = "/home/gabeg/.config/awesome/icons/bat/bat"
    
    
    -- Round battery percentages to whole numbers
    function round(num)
        return tonumber(string.format("%." .. (0) .. "f", num))
    end
    
    
    -- Determine battery status and charge
    local status = doCommand(batStat_cmd)
    local subStatus = string.sub(status, 0, 1)
    
    local percent = doCommand(bat_cmd)
    local subPercent = percent:gsub('%%','')
    local icon = nil
    
    -- Check if battery is charging
    if subStatus == "C" then 
        local batChargeIcon = mainBatIcon .. "-charge.png"
        icon = batChargeIcon
    else
        
        -- Else display the various charge level icons
        subPercent = subPercent + 0
        
        -- Define the icon path
        icon = mainBatIcon .. round(subPercent) .. ".png"
    end
    
    panel:set_image(icon)
end



-- ---------------------------------------
-- DISPLAY BATTERY AND SYSTEM NOTIFICATION
-- ---------------------------------------

-- Displays the battery notification
function disp_batMenu(timeout, hover_timeout)
    
    -- Battery commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local bat_cmd = mainDir .. "comp bat"
    local bat_stat_cmd = mainDir .. "comp bat stat"
    local bat_time_cmd = "acpi -b | cut -f3 -d',' | cut -f2 -d' '"
    
    
    -- Define notification timeout if not set
    if timeout == nil then timeout = 0 end
    if hover_timeout == nil then hover_timeout = 0 end
    
    
    -- Kill old notification bubbles
    naughty.destroy(batMenu)
    naughty.destroy(sysMenu)
    
    
    -- Notification battery data
    local batData = doCommand(bat_cmd)
    local batStatData = doCommand(bat_stat_cmd)
    local batTimeData = doCommand(bat_time_cmd)
    
    
    -- Compile all the data together
    local batDispData = string.format('<span font_desc="Inconsolata 9">%s</span>', 
                                      'Battery Status:  ' .. batStatData ..
                                          "\nBattery Charge:  " .. batData ..
                                          "\nTime Remaining:  "  .. batTimeData 
                                     )
    
    -- Display the battery notification
    batMenu = naughty.notify( { text = batDispData,
                                timeout = 0, hover_timeout = 0
                              } )
    
    -- Set battery widget icon
    setBatIcon(myBatteryImage)
end



-- Displays the system notification
function disp_sysMenu(timeout, hover_timeout)
    
    -- System commands
    local mainDir = "/mnt/Linux/Share/scripts/"
    local uptime_cmd = mainDir .. "comp up"
    local cpu_cmd = mainDir .. "comp cpu"
    local mem_cmd = mainDir .. "comp mem"
    -- local temp_cmd = mainDir .. "comp temp"
    
    
    -- Define notification timeout if not set
    if timeout == nil then timeout = 0 end
    if hover_timeout == nil then hover_timeout = 0 end
    
    
    -- Kill old notification bubbles
    naughty.destroy(batMenu)
    naughty.destroy(sysMenu)
    
    
    -- Notification system data
    local upData = doCommand(uptime_cmd)
    local cpuData = doCommand(cpu_cmd)
    local memData = doCommand(mem_cmd)
    -- local tempData = doCommand(temp_cmd)
        
    
    -- Compile all the data together
    local sysTitle = string.format('<span style="oblique" underline="low" ' ..
                                   'weight="bold" font_desc="Inconsolata 9">%s</span>',
                                   '      System Information      '
                                  )
    
    local sysDispData = string.format('<span font_desc="Inconsolata 9">%s</span>', 
                                  upData  .. 
                                      "\n"  .. memData .. 
                                      "\n\n" ..  cpuData  
                                 )
    
    
    -- Display the system notification    
    sysMenu = naughty.notify( { text = sysTitle .. "\n\n" .. sysDispData,
                                timeout = 0, hover_timeout = 0
                              } )
    
    
    -- Set battery widget icon
    setBatIcon(myBatteryImage)
end



-- ---------------------------------------
-- ENABLE BATTERY WIDGET MOUSE HOVER EVENT
-- ---------------------------------------

-- Make battery widget display computer info on mouse hover
function batHover(myBatteryImage)
    
    -- Kill old notification bubbles
    naughty.destroy(batMenu)
    naughty.destroy(sysMenu)
    
    
    -- Set battery imagebox buttons
    myBatteryImage:buttons( awful.util.table.join(
                                awful.button({ }, 1, function() disp_batMenu() end),
                                awful.button({ }, 3, function() disp_sysMenu() end) )
                          ) 
    
end



-- -------------------------
-- CREATE THE BATTERY WIDGET
-- -------------------------

-- Return battery widget (image and text)
function battery()
    
    -- Display battery warning if charge too low
    batWarning()
    
    -- Initialize battery image/text boxes
    myBatteryImage = wibox.widget.imagebox()
    
    
    -- Set widget icon and text
    setBatIcon(myBatteryImage)
    
    
    -- Battery imagebox mouse hover event
    myBatteryImage:connect_signal("mouse::enter", function() disp_batMenu() end)
    myBatteryImage:connect_signal("mouse::leave", function() naughty.destroy(batMenu) end)
    
    
    -- Return the image/text boxes
    return myBatteryImage
end
