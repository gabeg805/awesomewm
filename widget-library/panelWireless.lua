-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     panelWireless
-- 
-- 
-- Syntax: 
-- 	
--     panelWireless = require("panelWireless")
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
--     panelWireless.getIcon  - returns the correct wifi icon given the current
--                              wifi percentage value
--     disp_wireMenu          - displays the hover-enabled popup
--     add_wireMenu           - enables the popup
--     panelWireless.hover    - makes wireless widget hoverable, displays
--                              computer information on popup
--     panelWireless.wireless - returns the wireless widget
-- 
-- 
-- Dependencies:
--
--     awful   - Awesome builtin module
--     naughty - Awesome builtin module
--     wibox   - Awesome builtin module
-- 
--     panelText        - custom module, returns script output in string format or 
--                        as text for a widget
--     compInfo-Arch.sh - custom script, displays a wide variety of computer
--                        information
--   
--   
--  File Structure:
--
--     * Import Modules
--     * Define Necessary Variables
--     * Define the Module
--     * Create the Wifi Widget
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

-- wireless icons for different percentage values
local wireNone = "/home/gabeg/.config/awesome/icons/wireless/wireNone.png"
local wire0 = "/home/gabeg/.config/awesome/icons/wireless/wire0-25.png"
local wire25 = "/home/gabeg/.config/awesome/icons/wireless/wire25-50.png"
local wire50 = "/home/gabeg/.config/awesome/icons/wireless/wire50-75.png"
local wire75 = "/home/gabeg/.config/awesome/icons/wireless/wire75-100.png"

-- scripts to get computer info
net_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh net"
ssid_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh net ssid"



-- *****************
-- DEFINE THE MODULE
-- *****************

function make_module(name, definer)
   local module = {}
   definer(module)
   package.loaded[name] = module
   return module
end
 



-- **********************
-- CREATE THE WIFI WIDGET
-- **********************

panelWireless = make_module('panelWireless',
                            function(panelWireless)
                                
                                -- sets the icon for the wifi widget
                                panelWireless.getIcon = function(panel, command)
                                    local percent = panelText.subGetScript(net_cmd)
                                    local subPercent = percent:gsub('%%', '') 
                                    local subStatus = string.sub(percent, 0, 1)
                                    local icon = ""
                                    
                                    if subStatus == "S" then 
                                        icon = wireNone
                                    else
                                        
                                        subPercent = subPercent + 0
                                        
                                        if subPercent > 0 and subPercent < 25 then
                                            icon = wire0
                                        elseif subPercent >= 25 and subPercent < 50 then
                                            icon = wire25
                                        elseif subPercent >= 50 and subPercent < 75 then
                                            icon = wire50
                                        elseif subPercent >= 75 then
                                            icon = wire75
                                        end
                                    end
                                    
                                    panel:set_image(icon)
                                end
                                
                                
                                -- makes wifi widget hoverable (displays popup)
                                panelWireless.hover = function(myWirelessImage)
                                    naughty.destroy(wireMenu)
                                                                            
                                    -- computer info to display on popup
                                    ssidData = panelText.subGetScript(ssid_cmd)
                                    netData  = panelText.subGetScript(net_cmd)
                                    
                                    wireMenu = naughty.notify( { text = ssidData .. "Strength: " .. netData,
                                                                 font = "Inconsolata 10", 
                                                                 timeout = 0, hover_timeout = 0,
                                                                 width = 150,
                                                                 height = 45,
                                                               } )
                                    
                                    
                                    -- enable mouse events for textclock widget
                                    myWirelessImage:buttons( awful.util.table.join( 
                                                                 awful.button({ }, 4, function () panelWireless.hover(myWirelessImage) end),
                                                                 awful.button({ }, 5, function () panelWireless.hover(myWirelessImage) end) ) 
                                                           )
                                end
                                
                                
                                -- returns the wifi widget (image and text)
                                panelWireless.wireless = function()
                                    myWirelessImage = wibox.widget.imagebox()
                                    
                                    panelWireless.getIcon(myWirelessImage, net_cmd)
                                    
                                    myWirelessImage:connect_signal("mouse::enter", function() panelWireless.hover(myWirelessImage) end)
                                    myWirelessImage:connect_signal("mouse::leave", function() naughty.destroy(wireMenu) end)                                    
                                    
                                    return myWirelessImage
                                end
                                
                            end
                           )
                               
