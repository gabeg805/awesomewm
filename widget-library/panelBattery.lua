-- 
-- Created By: Gabriel Gonzalez  
-- 
-- 
-- Name:
-- 	
--     panelBattery
-- 
-- 
-- Syntax: 
-- 	
--     panelBattery = require("panelBattery")
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
--     panelBattery.warning - displays a warning when battery charge 
--                            is low
--     panelBattery.getIcon - returns the correct battery icon given the 
--                            current battery percentage value
--     panelBattery.click   - makes battery widget clickable, displays
--                            computer information on popup
--     remove_batMenu       - removes the click-enabled popup
--     add_batMenu          - displays the click-enabled popup
--     panelBattery.battery - returns the battery widget (image and text)
-- 
-- 
-- Dependencies:
--
--     awful   - Awesome builtin module
--     naughty - Awesome builtin module
--     wibox   - Awesome builtin module
-- 
--     panelText - returns script output in string format or as text for a widget
--   
--   
--  File Structure:
--
--     * Import Modules
--     * Define Necessary Variables
--     * Define the Module
--     * Create the Battery Widget
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
--
-- ************************************************************************



-- **************
-- IMPORT MODULES
-- **************

local panelText = require("panelText")



-- **************************
-- DEFINE NECESSARY VARIABLES
-- **************************

-- battery icons for different percentage values
local batChargeIcon = "/home/gabeg/.config/awesome/icons/bat/bat-charge.png"
local bat0Icon = "/home/gabeg/.config/awesome/icons/bat/bat0-15.png"
local bat15Icon = "/home/gabeg/.config/awesome/icons/bat/bat15-30.png"
local bat30Icon = "/home/gabeg/.config/awesome/icons/bat/bat30-45.png"
local bat45Icon = "/home/gabeg/.config/awesome/icons/bat/bat45-60.png"
local bat60Icon = "/home/gabeg/.config/awesome/icons/bat/bat60-75.png"
local bat75Icon = "/home/gabeg/.config/awesome/icons/bat/bat75-90.png"
local bat90Icon = "/home/gabeg/.config/awesome/icons/bat/bat90-99.png"
local bat100Icon = "/home/gabeg/.config/awesome/icons/bat/bat100.png"


-- scripts that print out various computer information
stat_cmd = "/mnt/Linux/Share/scripts/compInfo.sh bat stat"
bat_cmd = "/mnt/Linux/Share/scripts/compInfo.sh bat"
cpu_cmd = "/mnt/Linux/Share/scripts/compInfo.sh cpu"
mem_cmd = "/mnt/Linux/Share/scripts/compInfo.sh mem"
temp_cmd = "/mnt/Linux/Share/scripts/compInfo.sh temp"
uptime_cmd = "/mnt/Linux/Share/scripts/compInfo.sh up"


-- system actions
local shuttingDown = "sudo shutdown -P now"



-- *****************
-- DEFINE THE MODULE
-- *****************

function make_module(name, definer)
   local module = {}
   definer(module)
   package.loaded[name] = module
   return module
end
 



-- *************************
-- CREATE THE BATTERY WIDGET
-- *************************

panelBattery = make_module('panelBattery',
                           function(panelBattery)

                               -- displays a warning if battery charge is too low
                               panelBattery.warning = function()
                                   local percent = panelText.subGetScript(bat_cmd)
                                   local subPercent = percent:gsub('%W','') + 0
                                   
                                   
                                   -- shut down computer
                                   if subPercent < 10 then
                                       os.execute(shuttingDown)
                                   end
                                   
                                   
                                   -- displays the warning
                                   if subPercent < 15 then
                                       naughty.notify( {
                                                           text = "Arch Linux will shutdown at 10%.",
                                                           title = "SYSTEM ALERT",
                                                           position = "top_right",
                                                           timeout = 15,
                                                           -- icon="/path/to/image",
                                                           -- fg="#ffggcc",
                                                           -- bg="#bbggcc",
                                                           screen = 1,
                                                           ontop = false
                                                       } )
                                   end
                               end



                               
                               -- sets the icon for the battery widget
                               panelBattery.getIcon = function(panel, command)
                                   local status = panelText.subGetScript(stat_cmd)
                                   local subStatus = string.sub(status, 0, 1)
                                   
                                   local percent = panelText.subGetScript(bat_cmd)
                                   local subPercent = string.sub(percent, 0, 3)
                                   

                                   if subStatus == "C" then 
                                       icon = batChargeIcon
                                   else
                                       
                                       subPercent = subPercent + 0
                                       
                                       if subPercent > 0 and subPercent < 15 then
                                           icon = bat0Icon
                                       elseif subPercent >= 15 and subPercent < 30 then
                                           icon = bat15Icon 
                                       elseif subPercent >= 30 and subPercent < 45 then
                                           icon = bat30Icon
                                       elseif subPercent >= 45 and subPercent < 60 then
                                           icon = bat45Icon
                                       elseif subPercent >= 60 and subPercent < 75 then
                                           icon = bat60Icon
                                       elseif subPercent >= 75 and subPercent < 90 then
                                           icon = bat75Icon
                                       elseif subPercent >= 90 and subPercent < 100 then
                                           icon = bat90Icon
                                       elseif subPercent == 100 then
                                           icon = bat100Icon
                                       end
                                   end
                                   
                                   panel:set_image(icon)
                               end
                               
                               
                                                              
                               
                               -- makes the battery widget clickable (displays computer info)
                               panelBattery.click = function(myBattery)
                                   local batMenu = nil
                                   
                                   
                                   -- remove the battery widget popup
                                   function remove_batMenu()
                                       if batMenu ~= nil then
                                           naughty.destroy(batMenu)
                                           batMenu = nil
                                       end
                                   end
                                   
                                   
                                   -- display the battery widget popup
                                   function add_batMenu()
                                       remove_batMenu()
                                       
                                       -- script output to display in battery menu
                                       upData = panelText.subGetScript(uptime_cmd)
                                       tempData = panelText.subGetScript(temp_cmd)
                                       cpuData = panelText.subGetScript(cpu_cmd)
                                       memData = panelText.subGetScript(mem_cmd)
                                       
                                       newline = "\n" .. "\n"
                                       
                                       
                                       batMenu = naughty.notify( { text = 
                                                                   string.format('<span style="oblique" ' ..
                                                                                 'underline="low" ' ..
                                                                                 'weight="bold" ' ..
                                                                                 'font_desc="Inconsolata 9">%s</span>',
                                                                                 "      System Information      ") ..
                                                                                               newline ..
                                                                                               
                                                                                               string.format('<span font_desc="%s">%s</span>', 
                                                                                                             "Inconsolata 10", 
                                                                                                             upData  .. tempData ..
                                                                                                                 "\n"  .. 
                                                                                                                 memData .. 
                                                                                                                 "\n" ..
                                                                                                                 cpuData  
                                                                                                            ),
                                                                   timeout = 0, hover_timeout = 1,
                                                                   width = 227,
                                                                   height = 180,
                                                                 } )
                                       return 
                                   end
                                   
                                   
                                   -- enable mouse events for textclock widget
                                   myBattery:buttons( awful.util.table.join( 
                                                          awful.button({ }, 1, function () add_batMenu() end)
                                                                           )
                                                    )
                               end
                               
                               
                               
                               -- returns the battery widget (image and text)
                               panelBattery.battery = function()
                                   panelBattery.warning()
                                   
                                   myBatteryImage = wibox.widget.imagebox()
                                   myBatteryTextBox = wibox.widget.textbox()
                                   
                                   panelBattery.getIcon(myBatteryImage, bat_cmd)
                                   panelText.getScript(myBatteryTextBox, bat_cmd, "#333333")
                                   panelBattery.click(myBatteryTextBox)
                                   
                                   return myBatteryImage, myBatteryTextBox
                               end
                               
                           end
                          )
