-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     gabegWidgets
-- 
-- 
-- Syntax: 
-- 	
--     gabegWidgets = require("gabegWidgets")
-- 
-- 
-- Purpose:
-- 	
--     Insert custom widgets to panel.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     gabegWidgets.aweMenu    - create Awesome menu
--     gabegWidgets.clock      - create Awesome text clock
--     gabegWidgets.panLayouts - define panel layouts
--     gabegWidgets.getScript  - get outpu from custom scripts
--     gabegWidgets.setTime    - set the widget refresh timer
-- 
-- 
-- Dependencies:
--
--     awful     - Awesome builtin module
--     beautiful - Awesome builtin module
--     naughty   - Awesome builtin module
--     menubar   - Awesome builtin module
--     
--     panelLayouts    - custom module, sets the wallpaper and returns the Awesome tiling algorithms
--     panelMenu       - custom module, returns Awesome menu launcher
--     panelClock      - custom module, returns text clock (image and text)
--     panelText       - custom module, returns script output in string format and
--                       widget text format
--     panelBattery    - custom module, returns battery widget (image and text)
--     panelWireless   - custom module, returns wifi widget (image and text)
--     panelVolume     - custom module, returns volume widget (image and text)
--     panelTimer      - custom module, refreshes widgets with updated values
--     panelBrightness - custom module, returns brightness widget (image and text)
--     panelMusic      - custom module, returns music widget (image and text)
--
--   
--  File Structure:
--
--     * Edit Package Path
--     * Import Modules
--     * Compile All The Modules
--     * Awesome Menu
--     * Text Clock With Calendar
--     * Panel Layouts
--     * Set Panel Text
--     * Set Panel Timer
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 08 2014 <> created
--
-- ************************************************************************




-- *****************
-- EDIT PACKAGE PATH
-- *****************

package.path = package.path .. ';/home/gabeg/.config/awesome/widget-library/?.lua'



-- **************
-- IMPORT MODULES
-- **************

local panelLayouts = require("panelLayouts")
local panelMenu = require("panelMenu")
local panelClock = require("panelClock")
local panelText = require("panelText")
local panelBattery = require("panelBattery")
local panelWireless = require("panelWireless")
local panelVolume = require("panelVolume")
local panelTimer = require("panelTimer")
local panelBrightness = require("panelBrightness")
local panelMusic = require("panelMusic")



-- ***********************
-- COMPILE ALL THE MODULES
-- ***********************

function make_module(name, definer)
   local module = {}
   definer(module)
   package.loaded[name] = module
   return module
end


gabegWidgets = make_module('gabegWidgets',
                           function(gabegWidgets)
                               
                               gabegWidgets.wallpaper = panelLayouts.wallpaper
                               gabegWidgets.layouts = panelLayouts.layouts
                               
                               gabegWidgets.aweMenu = panelMenu.aweMenu
                               gabegWidgets.clock = panelClock.clock
                               
                               gabegWidgets.battery = panelBattery.battery
                               gabegWidgets.wireless = panelWireless.wireless
                               gabegWidgets.volume = panelVolume.volume
                               gabegWidgets.brightness = panelBrightness.brightness
                               gabegWidgets.music = panelMusic.music
                               
                               gabegWidgets.setTimer = panelTimer.timer
                               gabegWidgets.setMusicTimer = panelTimer.musicTimer
                           end
                           
                          )

