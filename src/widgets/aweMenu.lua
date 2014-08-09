-- 
-- CREATED BY: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- NAME:
-- 	
--     aweMenu
-- 
-- 
-- SYNTAX: 
-- 	
--     require("aweMenu")
-- 
-- 
-- PURPOSE:
-- 	
--     Returns the Awesome launcher widget so that the user can it on the panel.
-- 
-- 
-- KEYWORDS:
-- 	
--     N/A
-- 
-- 
-- FUNCTIONS:
-- 	
--     aweMenu - returns the Awesome launcher with several Awesome options, as well
--               as several System options (such as shut down and reboot)
-- 
-- 
--  FILE STRUCTURE:
--
--     * Create the Awesome Menu Launcher
-- 
-- 
-- MODIFICATION HISTORY:
-- 	
--     gabeg Mar 13 2014 <> created
-- 
--     gabeg Jul 26 2014 <> updated the program to make it easier to use
--
-- **********************************************************************************


-- --------------------------------------------
-- ----- CREATE THE AWESOME MENU LAUNCHER -----
-- --------------------------------------------

-- Create a laucher widget and a main menu (creates awesome A for panel)
function aweMenu()

    -- Icons to display
    local menuIconsDir = "/home/gabeg/.config/awesome/icons/menu/"    
    local archyIcon = theme.awesome_icon
    local fireIcon = menuIconsDir .. "mozilla.png"
    local emacsIcon = menuIconsDir .. "emacs.png"
    local termIcon = menuIconsDir .. "term-icon.png"
    local compIcon = menuIconsDir .. "comp.png"
    local hibIcon = menuIconsDir .. "hibernate.png"
    local rebIcon = menuIconsDir .. "reboot.png"
    local shuIcon = menuIconsDir .. "shutdown.png"
    
    
    -- System Power commands 
    local pow = "/usr/bin/systemctl"
    local rebooting = pow .. " " .. "reboot"
    local shuttingDown = pow .. " " .. "poweroff"
    local hibernating = pow .. " " .. "hibernate"
    
    
    -- Awesome Sub Menu
    myAwesomeMenu = {
        { "Restart", awesome.restart },
        { "Quit", awesome.quit }
    }
    
    
    -- System Sub Menu
    mySystemMenu = {
        { " Hibernate",  hibernating,    hibIcon },
        { " Reboot",     rebooting,      rebIcon }, 
        { " Shut Down",  shuttingDown,   shuIcon }
    }
    
    
    -- Main items in the menu
    myMainMenu = awful.menu( { items = { 
                                   { " Awesome",    myAwesomeMenu,  beautiful.awesome_icon },
                                   { " Firefox",    browser,        fireIcon       },
                                   { " Emacs",      editor,         emacsIcon      },
                                   { " Terminal",   terminal,       termIcon       },
                                   { " System",     mySystemMenu,   compIcon       },
                                       }, 
                               theme = { width = 300, height = 30 }
                             } )
    
    
    -- Create the launcher
    local mylauncher = awful.widget.launcher( { image = archyIcon, menu = myMainMenu } )
    
    
    -- Return the launcher
    return mylauncher
end
