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
--                                     wifi percentage value
--     panelWireless.click    - makes wireless widget clickable, displays
--                              computer information on popup
--     remove_wireMenu        - removes the click-enabled popup
--     add_wireMenu           - displays the click-enabled popup
--     panelWireless.wireless - returns the wireless widget (image and text)
-- 
-- 
-- Dependencies:
--
--     awful   - Awesome builtin module
--     naughty - Awesome builtin module
--     wibox   - Awesome builtin module
-- 
--     panelText - custom module, returns script output in string format or 
--                 as text for a widget
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
local wire0 = "/home/gabeg/.config/awesome/icons/wireless/wire0-35.png"
local wire35 = "/home/gabeg/.config/awesome/icons/wireless/wire35-70.png"
local wire70 = "/home/gabeg/.config/awesome/icons/wireless/wire70-100.png"

-- scripts to get computer info
net_cmd = "/mnt/Linux/Share/scripts/compInfo.sh net"
ssid_cmd = "/mnt/Linux/Share/scripts/compInfo.sh net ssid"



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
                                    local subPercent = string.sub(percent, 0, 3)
                                    
                                    local subStatus = string.sub(percent, 0, 1)
                                                                       
                                    
                                    if subStatus == "S" then 
                                        icon = wireNone
                                    else
                                        
                                        subPercent = subPercent + 0
                                        
                                        if subPercent > 0 and subPercent < 35 then
                                            icon = wire0
                                        elseif subPercent >= 35 and subPercent < 70 then
                                            icon = wire35
                                        elseif subPercent >= 70 then
                                            icon = wire70
                                        end
                                    end
                                    
                                    panel:set_image(icon)
                                end
                                
                                
                                -- makes wifi widget clickable (displays popup)
                                panelWireless.click = function(myWireless)
                                    local wireMenu = nil
                                    
                                    -- remove the wifi popup
                                    function remove_wireMenu()
                                        if wireMenu ~= nil then
                                            naughty.destroy(wireMenu)
                                            wireMenu = nil
                                        end
                                    end
                                    
                                    
                                    -- display the wifi popup
                                    function add_wireMenu()
                                        remove_wireMenu()
                                        
                                        -- computer info to display on popup
                                        ssidData = panelText.subGetScript(ssid_cmd)
                                        
                                        wireMenu = naughty.notify( { text = string.format('<span font_desc="%s">%s</span>', 
                                                                                          "Inconsolata 10", 
                                                                                          ssidData ),
                                                                     timeout = 0, hover_timeout = 1,
                                                                     width = 150,
                                                                     height = 30,
                                                                   } )
                                        return 
                                    end
                                    
                                    
                                    -- enable mouse events for textclock widget
                                    myWireless:buttons( awful.util.table.join( 
                                                            awful.button({ }, 1, function () add_wireMenu() end)
                                                                             )
                                                      )
                                end
                                
                                
                                -- returns the wifi widget (image and text)
                                panelWireless.wireless = function()
                                    myWirelessImage = wibox.widget.imagebox()
                                    myWirelessTextBox = wibox.widget.textbox()
                                    
                                    panelWireless.getIcon(myWirelessImage, net_cmd)
                                    panelText.getScript(myWirelessTextBox, net_cmd, "#006699")
                                    panelWireless.click(myWirelessTextBox)
                                    
                                    return myWirelessImage, myWirelessTextBox
                                end
                                
                            end
                           )
                               
