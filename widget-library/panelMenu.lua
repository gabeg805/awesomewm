-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     panelMenu
-- 
-- 
-- Syntax: 
-- 	
--     panelMenu = require("panelMenu")
-- 
-- 
-- Purpose:
-- 	
--     Returns the Awesome launcher widget so that the user can it on the panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     aweMenu                - create the awesome submenu
--     sysMenu                - create the system submenu
--     panelMenu.aweMenu      - returns the Awesome launcher with several Awesome
--                              options, as well as several System options 
--                              (such as shut down and reboot).
--     panelMenu.resetAweMenu - returns a backup of the Awesome launcher

-- 
-- 
-- Dependencies:
--
--     awful     - Awesome builtin module
--     beautiful - Awesome builtin module
--   
--   
--  File Structure:
--
--     * Define Necessary Variables
--     * Define the Module
--     * Create the Awesome Launcher
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
--
-- ************************************************************************



-- **************************
-- DEFINE NECESSARY VARIABLES
-- **************************

-- icons to display
menuIconsDir = "/home/gabeg/.config/awesome/icons/menu/"

archyIcon = menuIconsDir .. "arch-icon.png"

fireIcon = menuIconsDir .. "mozilla.png"
emacsIcon = menuIconsDir .. "emacs.png"
termIcon = menuIconsDir .. "term-icon.png"
compIcon = menuIconsDir .. "comp.png"

hibIcon = menuIconsDir .. "hibernate.png"
rebIcon = menuIconsDir .. "reboot.png"
shuIcon = menuIconsDir .. "shutdown.png"

usbIcon = menuIconsDir .. "usb.png"


-- *****************
-- DEFINE THE MODULE
-- *****************
 
function make_module(name, definer)
   local module = {}
   definer(module)
   package.loaded[name] = module
   return module
end
 



-- ***************************
-- CREATE THE AWESOME LAUNCHER
-- ***************************

panelMenu = make_module('panelMenu',
                        function(panelMenu)
                            
                            
                            -- Create a laucher widget and a main menu (creates awesome A for panel)
                            panelMenu.aweMenu = function()
                                
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
                            
                            
                            
                            
                            -- Create a backup of laucher widget (for when menu items are added and you want to remove them)
                            panelMenu.resetAweMenu = function()
                                
                                local myAwesomeMenu = aweMenu()
                                local mySystemMenu = sysMenu()
                                
                                
                                -- Create a backup of the launcher
                                local myOrigMenu = awful.menu( { items = { 
                                                               { " Awesome",    myAwesomeMenu,  beautiful.awesome_icon },
                                                               { " Firefox",    browser,        fireIcon       },
                                                               { " Emacs",      editor,         emacsIcon      },
                                                               { " Terminal",   terminal,       termIcon       },
                                                               { " System",     mySystemMenu,   compIcon       },
                                                                   }, 
                                                           theme = { width = 300, height = 30 }
                                                         } )
                                
                                
                                -- Create the launcher
                                local myOrigLauncher = awful.widget.launcher( { image = archyIcon, menu = myOrigMenu } )
                                
                                
                                -- Return the launcher
                                return myOrigLauncher
                            end
                            
                        end
                       )

                            -- Return a USB Menu for the given device
                            -- function mkUsbMenu(device) 
                                
                            --     -- USB Sub Menu
                            --     local myUsbMenu = {
                            --         { " Open Directory", terminal .. " -cd " .. "/media" },
                            --         { " Unmount",        "udisks --unmount " .. device }
                            --     }
                                
                            --     -- Return the Menu
                            --     return myUsbMenu
                            -- end
                            
                            
                            -- Awesome Sub Menu
                            -- function aweMenu() 
                            --     local myAwesomeMenu = {
                            --         { "Restart", awesome.restart },
                            --         { "Quit", awesome.quit }
                            --     }
                                
                            --     return myAwesomeMenu
                            -- end
                            
                            
                            -- System Sub Menu
                            -- function sysMenu()
                            --     local mySystemMenu = {
                            --         { " Hibernate",  hibernating,    hibIcon },
                            --         { " Reboot",     rebooting,      rebIcon }, 
                            --         { " Shut Down",  shuttingDown,   shuIcon }
                            --     }
                                
                            --     return mySystemMenu
                            -- end
                                
                            
                            
                            
                            
