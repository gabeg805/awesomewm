-- 
-- Created By: Gabriel Gonzalez
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
--     panelMenu.aweMenu - returns the Awesome launcher with several Awesome
--                         options, as well as several System options 
--                         (such as shut down and reboot).
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

-- used as the default terminal and editor to run
terminal = "urxvt"
editor = "emacs"
editor_cmd = terminal .. " -e " .. editor

-- commands to add in Awesome menu
local browser = "firefox"
local text = "emacs"
local rebooting = "sudo reboot"
local shuttingDown = "sudo shutdown -P now"

-- icons to display
local archyIcon = "/home/gabeg/.config/awesome/icons/arch-icon.png"
local fireIcon = "/usr/lib/firefox/browser/icons/mozicon128.png"
local emacsIcon = "/usr/share/emacs/24.3/etc/images/icons/hicolor/32x32/apps/emacs.png"



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
                                myAwesomeMenu = {
                                    { "edit config", editor_cmd .. " " .. awesome.conffile },
                                    { "restart", awesome.restart },
                                    { "quit", awesome.quit }
                                }
                                
                                
                                myMainMenu = awful.menu( { items = { 
                                                               { " Awesome", myAwesomeMenu, beautiful.awesome_icon },
                                                               { " Firefox", browser, fireIcon },
                                                               { " Emacs", text, emacsIcon },
                                                               { " Reboot", rebooting }, 
                                                               { " Shut Down", shuttingDown }
                                                                   }
                                                         } )
                                
                                mylauncher = awful.widget.launcher( { image = archyIcon, menu = myMainMenu } )
                                mylauncher:connect_signal("mouse::leave", function() myMainMenu:toggle() end)
                                return mylauncher
                            end
                            
                        end
                       )