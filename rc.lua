-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- Name:
-- 	
--     rc.lua
-- 
-- 
-- Syntax: 
-- 	
--     rc.lua
-- 
-- 
-- Purpose:
-- 	
--     Main configuration file for Awesome.
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
--     gears     - Awesome builtin module
--     awful     - Awesome builtin module
--     wibox     - Awesome builtin module
--     beautiful - Awesome builtin module
--     naughty   - Awesome builtin module
--     menubar   - Awesome builtin module
--     
--     error_check.lua  - checks for errors on compile
--     aweInterface.lua - sets Awesome interface, adds widgets to panel, 
--                        defines tiling algorithms, sets wallpaper, etc.
--     keyindings.lua   - defines Awesome key and mouse bindings
--    
--    
--  File Structure:
--
--     * Import Libraries
--     * Global Variables
--     * Set Up the Awesome WM
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 08 2014 <> created
--
-- **********************************************************************************



-- ----------------
-- IMPORT LIBRARIES
-- ----------------

-- Add custom widgets to the package path
package.path = package.path .. ';/home/gabeg/.config/awesome/src/?.lua;/home/gabeg/.config/awesome/src/widgets/?.lua'


-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")


-- Widget library
wibox = require("wibox")


-- Theme handling library
beautiful = require("beautiful")


-- Notification library
naughty = require("naughty")
menubar = require("menubar")


-- Custom modules for the Awesome layout and Linux command execution
require("aweLayout")
require("commandline")



-- ----------------
-- GLOBAL VARIABLES
-- ----------------

-- Default file manager, terminal, editor, and browser
fileman = "nautilus"
terminal = "urxvt"
editor = "emacs"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"



-- ---------------------
-- SET UP THE AWESOME WM
-- ---------------------

-- Check for errors on compile
dofile("/home/gabeg/.config/awesome/src/error_check.lua")


-- Menubar configuration, Set the terminal for applications that require it
menubar.utils.terminal = terminal

-- Set the Awesome wallpaper
setWallpaper("/home/gabeg/.config/awesome/other/wallpapers/smooth.jpg")

-- Define Awesome tiling layouts (algorithms)
layouts = setLayouts()

-- Define Awesome tags
tags = setTags( {"1", "2", "3", "4", "5"}, layouts )


-- Set Up Awesome Interface (Layouts, Widgets, Background, etc.)
dofile("/home/gabeg/.config/awesome/src/aweInterface.lua")

-- Mouse and Key Bindings
dofile("/home/gabeg/.config/awesome/src/keybindings.lua")
