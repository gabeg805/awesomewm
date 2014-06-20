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
--     aweBindings.lua  - defines Awesome key and mouse bindings
--    
--    
--  File Structure:
--
--     * Import Libraries
--     * Check For Errors On Compile
--     * Complete Awesome Set Up
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 08 2014 <> created
--
-- ************************************************************************



-- ****************
-- IMPORT LIBRARIES
-- ****************

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



-- ***************************
-- CHECK FOR ERRORS ON COMPILE
-- ***************************

dofile("/home/gabeg/.config/awesome/error_check.lua")



-- **********************
-- GLOBAL SCRIPT COMMANDS
-- **********************

mainDir = "/mnt/Linux/Share/scripts/"

-- Battery commands
bat_cmd = mainDir .. "compInfo-Arch.sh bat"
batStat_cmd = mainDir .. "compInfo-Arch.sh bat stat"


-- Brightness commands
bright_cmd = mainDir .. "compInfo-Arch.sh bright"
brightStat_cmd = bright_cmd .. " " .. "stat"
upBright_cmd = bright_cmd .. " " .. "inc"
downBright_cmd = bright_cmd .. " " .. "dec"



-- Music commands
musicRunStat_cmd = "pgrep -c mocp"
musicPause = "mocp -G"
musicNextSong = "mocp -f"
musicPrevSong = "mocp -r"
musicReplay = "mocp -p"
musicExit = "mocp -x"


-- Volume commands
vol_cmd = mainDir .. "compInfo-Arch.sh vol stat"
chVol_cmd = mainDir .. "compInfo-Arch.sh vol"
volMuteStat_cmd = mainDir .. "compInfo-Arch.sh vol muteStat"


-- Wireless network commands
net_cmd = mainDir .. "compInfo-Arch.sh net"
ssid_cmd = mainDir .. "compInfo-Arch.sh net ssid"


-- Comp-Info commands
cpu_cmd = mainDir .. "compInfo-Arch.sh cpu"
mem_cmd = mainDir .. "compInfo-Arch.sh mem"
temp_cmd = mainDir .. "compInfo-Arch.sh temp"
uptime_cmd = mainDir .. "compInfo-Arch.sh up"


-- Default file manager, terminal, editor, and browser
fileman = "nautilus"
terminal = "urxvt"
editor = "emacs"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"


-- System Power commands 
pow = mainDir .. "system/POWER"
rebooting = pow .. " " .. "reboot"
shuttingDown = pow .. " " .. "off"
hibernating = pow .. " " .. "hib"



-- ***********************
-- COMPLETE AWESOME SET UP
-- ***********************

-- Set Up Awesome Interface (Layouts, Widgets, Background, etc.)
dofile("/home/gabeg/.config/awesome/aweInterface.lua")

-- Mouse and Key Bindings
dofile("/home/gabeg/.config/awesome/aweBindings.lua")

