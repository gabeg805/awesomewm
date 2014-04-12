-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     panelCute
-- 
-- 
-- Syntax: 
-- 	
--     panelCute [NULL]
-- 
-- 
-- Purpose:
-- 	
--     Displays cute images when panel is clicked
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     N/A
-- 
-- 
-- Dependencies:
--
--     N/A
--   
--   
--  File Structure:
--
--     * N/A
-- 
-- 
-- Modification History:
-- 	
--     gabeg Apr 01 2014 <> created
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
cuteIcon = "/home/gabeg/.config/awesome/icons/cute.png"

-- script that prints out current volume value
list_cmd = "ls -v -1 /mnt/Linux/Share/docs/pics/fools/*.jpg"


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

panelCute = make_module('panelCute',
                              function(panelCute)
                                  
                                  -- sets the icon for the wifi widget
                                  function getIcon(panel)
                                      local icon = cuteIcon
                                      
                                      panel:set_image(icon)
                                  end
                                  
                                  
                                  -- get all the pics in the directory
                                  function getPics()
                                      local pics = panelText.subGetScript("ls -v -1 /mnt/Linux/Share/docs/pics/fools/*jpg")
                                      
                                      local array = {}
                                      local i = 0
                                      
                                      for str in string.gmatch(pics, "%S+") do
                                          array[i] = str
                                          i = i+1
                                      end
                                      
                                      return array
                                  end
                                  
                                  
                                  
                                  -- make cuteness widget hoverable (display popup)
                                  panelCute.click = function(myCuteImage) 
                                      local cuteMenu = nil
                                      local pics = getPics()
                                      local offset = 0
                                      
                                      
                                      -- display the cuteMenu popup
                                      function add_cuteMenu(incr)
                                          local saveOffset = offset
                                          offset = saveOffset + incr
                                          
                                          runID = panelText.subGetScript("pgrep qiv")
                                          os.execute("kill " .. " " .. runID)
                                          
                                          awful.util.spawn("qiv -w 300 " .. " " .. pics[offset])
                                      end
                                      
                                      
                                      
                                      -- enable mouse events for textclock widget
                                      myCuteImage:buttons( awful.util.table.join(
                                                               awful.button({ }, 1, function() add_cuteMenu(1) end),
                                                               awful.button({ }, 4, function() add_cuteMenu(1) end),
                                                               awful.button({ }, 5, function() add_cuteMenu(-1)  end)
                                                                                )
                                                         )

                                  end
                                  
                                  
                                  
                                  -- returns the cuteness widget (image and text)
                                  panelCute.cute = function()
                                      myCuteImage = wibox.widget.imagebox()
                                      getIcon(myCuteImage)
                                      
                                      panelCute.click(myCuteImage)
                                      
                                      return myCuteImage
                                  end
                                  
                              end
                             )