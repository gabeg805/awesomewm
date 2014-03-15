-- 
-- Created By: Gabriel Gonzalez
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
--     panelBrightness.click      - makes brightness widget clickable
--     remove_calendar            - removes the click-enabled popup
--     add_calendar               - displays the click-enabled popup
--     panelBrightness.brightness - returns the brightness widget (image and text)
-- 
-- 
-- Dependencies:
--
--     wibox - Awesome builtin module
-- 
--     panelText - custom module that converts the output from a script into
--                 a string or text for a panel widget 
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
local brightIcon = "/home/gabeg/.config/awesome/icons/brightness.png"

-- script that prints out current volume value
bright_cmd = "/mnt/Linux/Share/scripts/compInfo.sh bright stat"
bright_bare_cmd = "/mnt/Linux/Share/scripts/compInfo.sh bright stat-bare"
chBright_cmd = "/mnt/Linux/Share/scripts/compInfo.sh bright  "



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
                                  
                                  -- make brightness widget clickable (display popup)
                                  panelBrightness.click = function(myBrightness) 
                                      local brightMenu = nil
                                      local temp = panelText.subGetScript(bright_bare_cmd)
                                      
                                      local offset = temp + 0
                                      
                                      -- remove the brightMenu popup
                                      function remove_brightMenu()
                                          if brightMenu ~= nil then
                                              naughty.destroy(brightMenu)
                                              brightMenu = nil
                                              
                                              temp = panelText.subGetScript(bright_bare_cmd)
                                              offset = temp + 0
                                          end
                                      end
                                      
                                      
                                      -- display the brightMenu popup
                                      function add_brightMenu(incr)
                                          local saveOffset = offset
                                          
                                          remove_brightMenu()
                                          
                                          offset = saveOffset + incr
                                          
                                          os.execute(chBright_cmd .. offset)
                                          brightData = panelText.subGetScript(bright_cmd)
                                          
                                          brightMenu = naughty.notify( { text = string.format('<span font_desc="%s">%s</span>', 
                                                                                              "Inconsolata 10",  
                                                                                              "Brightness: " .. brightData
                                                                                             ),
                                                                         timeout = 0, hover_timeout = 1,
                                                                         width = 130,
                                                                         height = 30,
                                                                       } )
                                      end
                                      
                                      
                                      
                                      -- enable mouse events for textclock widget
                                      myBrightness:buttons( awful.util.table.join( 
                                                                awful.button({ }, 1, function () add_brightMenu(0) end),
                                                                awful.button({ }, 4, function() add_brightMenu(10) end),
                                                                awful.button({ }, 5, function() add_brightMenu(-10)  end)
                                                                                 )
                                                          )
                                  end
                                  
                                  
                                  
                                  -- returns the brightness widget (image and text)
                                  panelBrightness.brightness = function()
                                      myBrightnessImage = wibox.widget.imagebox()
                                      myBrightnessTextBox = wibox.widget.textbox()
                                      
                                      myBrightnessImage:set_image(brightIcon)

                                      panelText.getScript(myBrightnessTextBox, bright_cmd, "#ff3300")
                                      panelBrightness.click(myBrightnessTextBox)
                                      
                                      return myBrightnessImage, myBrightnessTextBox
                                  end
                                  
                              end
                             )