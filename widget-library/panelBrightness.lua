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

-- script that prints out current volume value
bright_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh bright stat"
chBright_cmd = "/mnt/Linux/Share/scripts/compInfo-Arch.sh bright  "



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
                                  
                                  -- sets the icon for the wifi widget
                                  panelBrightness.getIcon = function(panel, command)
                                      local percent = panelText.subGetScript(command)
                                      local subPercent = percent:gsub('%W','')
                                      local subStatus = nil
                                      
                                      if tonumber(subPercent) ~= nil then 
                                          subPercent = subPercent + 0
                                      else
                                          subPercent = 'Calculating...'
                                          subStatus = "C"
                                      end
                                      
                                      if subStatus == "C" then 
                                          icon = bright0
                                      else
                                                                                
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
                                  
                                  
                                  
                                  function disp_brightMenu(val)
                                      naughty.destroy(brightMenu)
                                      
                                      brightData = panelText.subGetScript(bright_cmd)
                                      
                                      brightMenu = naughty.notify( { text = "Brightness: " .. brightData,
                                                                     font = "Inconsolata 10",  
                                                                     timeout = 0, hover_timeout = 0,
                                                                     width = 130,
                                                                     height = 30
                                                                   } )
                                  end
                                  
                                  
                                  -- make brightness widget hoverable (display popup)
                                  panelBrightness.hover = function(myBrightnessImage) 
                                      local brightMenu = nil
                                      local temp = panelText.subGetScript(bright_cmd)
                                      local offset = temp:gsub('%%','') + 0
                                      
                                      
                                      -- display the brightMenu popup
                                      function add_brightMenu(incr)
                                          local saveOffset = offset
                                          offset = saveOffset + incr
                                          
                                          os.execute(chBright_cmd .. offset)
                                          
                                          disp_brightMenu(offset)
                                      end
                                      
                                      
                                      
                                      -- enable mouse events for textclock widget
                                      myBrightnessImage:buttons( awful.util.table.join( 
                                                                     awful.button({ }, 4, function() add_brightMenu(10) end),
                                                                     awful.button({ }, 5, function() add_brightMenu(-10)  end)
                                                                                      )
                                                               )

                                  end
                                  
                                  
                                  
                                  -- returns the brightness widget (image and text)
                                  panelBrightness.brightness = function()
                                      myBrightnessImage = wibox.widget.imagebox()
                                      
                                      panelBrightness.getIcon(myBrightnessImage, bright_cmd)
                                      
                                      myBrightnessImage:connect_signal("mouse::enter", function() panelBrightness.hover(myBrightnessImage); disp_brightMenu(0)  end)
                                      myBrightnessImage:connect_signal("mouse::leave", function() naughty.destroy(brightMenu) end)
                                                                            
                                      return myBrightnessImage
                                  end
                                  
                              end
                             )