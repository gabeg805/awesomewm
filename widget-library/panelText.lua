-- 
-- Created By: Gabriel Gonzalez
-- 
-- 
-- Name:
-- 	
--     panelText
-- 
-- 
-- Syntax: 
-- 	
--     panelText = require("panelText")
-- 
-- 
-- Purpose:
-- 	
--     Returns script output as text for a widget or as a string.
-- 
-- 
-- Keywords:
-- 	
--     N/A
-- 
-- 
-- Functions:
-- 	
--     panelText.getScript    - returns a TEXTBOX (a widget) with a specified color 
--                              and script output
--     panelText.subGetScript - returns specified script output as a string
-- 
-- 
-- Dependencies:
--
--     wibox - Awesome builtin module
--   
--   
--  File Structure:
--
--     * Define the Module
--     * Create the Set-Text Command
-- 
-- 
-- Modification History:
-- 	
--     gabeg Mar 13 2014 <> created
--
-- ************************************************************************



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
-- CREATE THE SET-TEXT COMMAND
-- ***************************

panelText = make_module('panelText',
                        function(panelText)

                            -- get output from custom script (returns a panel)
                            panelText.getScript = function(panel, command, color)
                                local comOutput =  io.popen(command)
                                local comData = comOutput:read("*all")
                                comOutput:close()
                                
                                panel:set_markup('<span background="' .. color .. '" font="Inconsolata 11" color="#EEEEEE">' ..
                                                 comData ..
                                                 '</span>')
                            end
                            
                            
                            
                            -- get output from custom script (returns a string)
                            panelText.subGetScript = function(command)
                                local comOutput = io.popen(command)
                                local comData = comOutput:read("*all")
                                comOutput:close()
                                
                                return comData
                            end
                            
                        end
                       )