-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     panelBrightness
-- 
-- 
-- Syntax: 
-- 	
--     panelBrightness = require("panelBrightness")
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
--     panelBrightness.hover      - makes brightness widget hoverable
--     add_calendar               - displays the hover-enabled popup
--     panelBrightness.brightness - returns the brightness widget (image and text)
-- 
-- 
-- Dependencies:
--
--     wibox - Awesome builtin module
-- 
--     panelText        - custom module that converts the output from a script into
--                        a string or text for a panel widget 
--     compInfo-Arch.sh - custom script, displays a wide variety of computer
--                        information
--   
--   
--  File Structure:
--
--     * Import Modules 
--     * Define Necessary Variables
--     * Define the Module
--     * Create the Brightness Widget
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

-- icons to display
-- local brightIcon = "/home/gabeg/.config/awesome/icons/brightness.png"
local bright0 = "/home/gabeg/.config/awesome/icons/bright/bright0-20.png"
local bright20 = "/home/gabeg/.config/awesome/icons/bright/bright20-40.png"
local bright40 = "/home/gabeg/.config/awesome/icons/bright/bright40-50.png"
local bright50 = "/home/gabeg/.config/awesome/icons/bright/bright50-60.png"
local bright60 = "/home/gabeg/.config/awesome/icons/bright/bright60-80.png"
local bright80 = "/home/gabeg/.config/awesome/icons/bright/bright80-100.png"



-- *****************
-- DEFINE THE MODULE
-- *****************

function make_module(name, definer)
    local module = {}
    definer(module)
    package.loaded[name] = module
    return module
end




-- ************************
-- CREATE THE VOLUME WIDGET
-- ************************

panelBrightness = make_module('panelBrightness',
                              function(panelBrightness)
                                  
                                  -- Sets the icon for the wifi widget
                                  panelBrightness.getIcon = function(panel, command, val)

                                      -- Check if a command was given, or a percent value
                                      local percent = nil
                                      local subPercent = nil
                                      
                                      if val ~= nil then
                                          percent = val
                                          subPercent = percent:gsub('%%', '')
                                      else
                                          percent = panelText.subGetScript(command)
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
                                          if subPercent > 0 and subPercent < 20 then
                                              icon = bright0
                                          elseif subPercent >= 20 and subPercent < 40 then
                                              icon = bright20
                                          elseif subPercent >= 40 and subPercent < 50 then
                                              icon = bright40
                                          elseif subPercent >= 50 and subPercent < 60 then
                                              icon = bright50
                                          elseif subPercent >= 60 and subPercent < 80 then
                                              icon = bright60
                                          elseif subPercent >= 80 and subPercent <= 100 then
                                              icon = bright80
                                          end
                                          
                                      end
                                      
                                                                            
                                      panel:set_image(icon)
                                  end
                                  
                                  
                                  
                                  -- Display the brightness notification
                                  function disp_brightMenu()
                                      
                                      -- Kill old notification
                                      naughty.destroy(brightMenu)
                                      
                                      -- Display the notification
                                      local brightData = panelText.subGetScript(brightStat_cmd)
                                      brightMenu = naughty.notify( { text = "Brightness: " .. brightData,
                                                                     font = "Inconsolata 10",  
                                                                     timeout = 0, hover_timeout = 0,
                                                                     width = 140,
                                                                     height = 30
                                                                   } )
                                  end
                                  
                                  
                                  -- Make brightness widget hoverable (display popup)
                                  panelBrightness.hover = function(myBrightnessImage) 
                                      local brightMenu = nil
                                      
                                      -- Display the brightness notification
                                      function add_brightMenu(incr)
                                          
                                          if incr < 0 then
                                              incr = -1 * incr
                                              os.execute(downBright_cmd .. "  " .. incr)
                                          else
                                              incr = -1 * incr
                                              os.execute(upBright_cmd .. "  " .. incr)
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
                                  
                                  
                                  
                                  -- Returns brightness widget (image and text)
                                  panelBrightness.brightness = function()
                                      
                                      -- Initialize brightness imagebox
                                      myBrightnessImage = wibox.widget.imagebox()
                                      
                                      -- Set widget icon
                                      panelBrightness.getIcon(myBrightnessImage, brightStat_cmd)
                                      
                                      
                                      -- Enable widget mouse events
                                      myBrightnessImage:connect_signal("mouse::enter", 
                                                                       function() 
                                                                           panelBrightness.hover(myBrightnessImage)
                                                                           disp_brightMenu()  
                                                                       end
                                                                      )
                                      
                                      myBrightnessImage:connect_signal("mouse::leave", function() naughty.destroy(brightMenu) end)
                                      
                                      
                                      -- Return the brightness widget
                                      return myBrightnessImage
                                  end
                                  
                              end
                             )
