-- 
-- Created By: Gabriel Gonzalez
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



-- ***********************
-- COMPLETE AWESOME SET UP
-- ***********************

-- Set Up Awesome Interface (Layouts, Widgets, Background, etc.)
dofile("/home/gabeg/.config/awesome/aweInterface.lua")

-- Mouse and Key Bindings
dofile("/home/gabeg/.config/awesome/aweBindings.lua")

