-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)  
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
--     panelBattery.hover   - makes battery widget hoverable, displays
--                            computer information on popup
--     add_batMenu          - displays the hover-enabled popup
--     panelBattery.battery - returns the battery widget (image and text)
-- 
-- 
-- Dependencies:
--
--     awful   - Awesome builtin module
--     naughty - Awesome builtin module
--     wibox   - Awesome builtin module
-- 
--     panelText        - returns script output in string format or as text for a widget
--     compInfo-Arch.sh - custom script, displays a wide variety of computer
--                        information
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
--     gabeg Mar 22 2014 <> removed widget text that would appear on the 
--                          panel and made it instead display in a popup.
--                          also made the popup appear when mouse hovers
--                          over the widget instead of by clicking
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
local bat0 = "/home/gabeg/.config/awesome/icons/bat/bat0-15.png"
local bat15 = "/home/gabeg/.config/awesome/icons/bat/bat15-30.png"
local bat30 = "/home/gabeg/.config/awesome/icons/bat/bat30-45.png"
local bat45 = "/home/gabeg/.config/awesome/icons/bat/bat45-60.png"
local bat60 = "/home/gabeg/.config/awesome/icons/bat/bat60-75.png"
local bat75 = "/home/gabeg/.config/awesome/icons/bat/bat75-90.png"
local bat90 = "/home/gabeg/.config/awesome/icons/bat/bat90-99.png"
local bat100 = "/home/gabeg/.config/awesome/icons/bat/bat100.png"



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

                               -- Display warning if battery charge is too low
                               panelBattery.warning = function()
                                   local status = panelText.subGetScript(batStat_cmd)
                                   local subStatus = string.sub(status, 0, 1)
                                   
                                   local percent = panelText.subGetScript(bat_cmd)
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
                                                           timeout = 15, hover_timeout = 0,
                                                           height = 40,
                                                           width = 250
                                                       } )
                                   end
                               end
                               
                               
                               
                               
                               -- Set icon for battery widget
                               panelBattery.getIcon = function(panel, command)
                                   local status = panelText.subGetScript(batStat_cmd)
                                   local subStatus = string.sub(status, 0, 1)
                                   
                                   local percent = panelText.subGetScript(bat_cmd)
                                   local subPercent = percent:gsub('%%','')
                                   local icon = nil
                                   
                                   
                                   -- Check if battery is charging
                                   if subStatus == "C" then 
                                       icon = batChargeIcon
                                   else
                                       
                                       -- Else display the various charge level icons
                                       subPercent = subPercent + 0
                                       
                                       if subPercent > 0 and subPercent < 15 then
                                           icon = bat0
                                       elseif subPercent >= 15 and subPercent < 30 then
                                           icon = bat15 
                                       elseif subPercent >= 30 and subPercent < 45 then
                                           icon = bat30
                                       elseif subPercent >= 45 and subPercent < 60 then
                                           icon = bat45
                                       elseif subPercent >= 60 and subPercent < 75 then
                                           icon = bat60
                                       elseif subPercent >= 75 and subPercent < 90 then
                                           icon = bat75
                                       elseif subPercent >= 90 and subPercent < 100 then
                                           icon = bat90
                                       elseif subPercent == 100 then
                                           icon = bat100
                                       end
                                   end
                                   
                                   panel:set_image(icon)
                               end
                               
                               
                                                              
                               
                               -- Make battery widget display computer info on mouse hover
                               panelBattery.hover = function(myBattery, myBatteryImage)
                                   
                                   -- Kill old battery notification 
                                   naughty.destroy(batMenu)
                                   
                                   -- Script output information for notification
                                   local upData = panelText.subGetScript(uptime_cmd)
                                   local tempData = panelText.subGetScript(temp_cmd)
                                   local cpuData = panelText.subGetScript(cpu_cmd)
                                   local memData = panelText.subGetScript(mem_cmd)
                                   
                                   -- Notification spacing
                                   local newline = "\n" .. "\n"
                                   
                                   
                                   -- Notification title
                                   local batTitle = string.format('' .. 
                                                                  '<span style="oblique" ' ..
                                                                  'underline="low" ' ..
                                                                  'weight="bold" ' ..
                                                                  'font_desc="Inconsolata 9">%s</span>',
                                                                  "      System Information      "
                                                                 )
                                   
                                   -- Notification data
                                   local batData = string.format('' ..
                                                                 '<span font_desc="Inconsolata 10">%s</span>', 
                                                                 upData  .. tempData ..
                                                                     "\n"  .. 
                                                                     memData .. 
                                                                     "\n" ..
                                                                     cpuData  
                                                                )
                                   
                                   
                                   -- The Battery notification
                                   batMenu = naughty.notify( { text = batTitle .. newline .. batData,
                                                               timeout = 0, hover_timeout = 0,
                                                               width = 227,
                                                               height = 180,
                                                             } )

                                   
                                   -- Set battery image/text box buttons
                                   myBattery:buttons( awful.util.table.join(
                                                          awful.button({ }, 1, 
                                                                       function() 
                                                                           panelBattery.hover(myBattery, myBatteryImage) 
                                                                       end
                                                                      ) ) 
                                                    ) 
                                   
                                   myBatteryImage:buttons( awful.util.table.join(
                                                               awful.button({ }, 1, function() panelBattery.hover(myBattery, myBatteryImage) end) )
                                                         ) 
                                   
                               end
                               
                               
                               
                               -- Return battery widget (image and text)
                               panelBattery.battery = function()
                                   
                                   -- Display battery warning if charge too low
                                   panelBattery.warning()
                                   
                                   -- Initialize battery image/text boxes
                                   myBatteryImage = wibox.widget.imagebox()
                                   myBatteryTextBox = wibox.widget.textbox()
                                   
                                   -- Set widget icon and text
                                   panelBattery.getIcon(myBatteryImage, bat_cmd)
                                   panelText.getScript(myBatteryTextBox, bat_cmd, "#333333")
                                   
                                   
                                   -- Battery textbox mouse mover event
                                   myBatteryTextBox:connect_signal("mouse::enter", 
                                                                   function() 
                                                                       panelBattery.getIcon(myBatteryImage, bat_cmd)
                                                                       panelText.getScript(myBatteryTextBox, bat_cmd, "#333333")
                                                                       panelBattery.hover(myBatteryTextBox, myBatteryImage) 
                                                                   end
                                                                  )
                                   
                                   myBatteryTextBox:connect_signal("mouse::leave", 
                                                                   function() 
                                                                       naughty.destroy(batMenu) 
                                                                   end
                                                                  )
                                   
                                   
                                   -- Battery imagebox mouse hover event
                                   myBatteryImage:connect_signal("mouse::enter", 
                                                                 function() 
                                                                     panelBattery.getIcon(myBatteryImage, bat_cmd)
                                                                     panelText.getScript(myBatteryTextBox, bat_cmd, "#333333")
                                                                     panelBattery.hover(myBatteryTextBox, myBatteryImage) 
                                                                 end
                                                                )
                                   
                                   myBatteryImage:connect_signal("mouse::leave", 
                                                                 function() 
                                                                     naughty.destroy(batMenu) 
                                                                 end
                                                                )
                                   
                                   
                                   -- Return the image/text boxes
                                   return myBatteryImage, myBatteryTextBox
                               end
                               
                           end
                          )
