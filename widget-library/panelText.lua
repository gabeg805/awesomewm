-- 
-- Created By: Gabriel Gonzalez (contact me at gabeg@bu.edu)
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
--     panelText.pipe             - enables command piping
--     panelText.getPipeScript    - sets output from piped command as string for 
--                                  a widget
--     panelText.subGetPipeScript - returns output from piped command as a string
--     panelText.getScript        - returns a TEXTBOX (a widget) with a specified 
--                                  color and script output
--     panelText.subGetScript     - returns specified script output as a string
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
                            
                            -- Enables the ability to pipe commands
                            panelText.pipe = function(cmd, raw)
                                local f = assert(io.popen(cmd, 'r'))
                                local s = assert(f:read('*a'))
                                f:close()
                                
                                if raw then return s end
                                
                                s = string.gsub(s, '^%s+', '')
                                s = string.gsub(s, '%s+$', '')
                                s = string.gsub(s, '[\n\r]+', ' ')
                                
                                return s
                            end
                            
                                                        
                            
                            -- Sets the text from a piped command onto the panel
                            panelText.getPipeScript = function(panel, stuff, color)
                                panel:set_markup('<span font="Inconsolata 10" color="#EEEEEE">' ..
                                                 stuff ..
                                                 '</span>')
                            end
                            
                            
                            
                            -- Returns the output from a piped command as a string
                            panelText.subGetPipeScript = function(command)
                                local output = ""
                                local cmdPipe = (command):gsub('$output', output)
                                output = panelText.pipe(cmdPipe)
                                
                                return output
                            end
                            
                                                        
                            
                            -- Get output from custom script (returns a panel)
                            panelText.getScript = function(panel, command, color)
                                local comOutput =  io.popen(command)
                                local comData = comOutput:read("*all")
                                comOutput:close()
                                
                                panel:set_markup('<span background="' .. color .. '" font="Inconsolata 11" color="#EEEEEE">' ..
                                                 comData ..
                                                 '</span>')
                            end
                            
                            
                            
                            -- Get output from custom script (returns a string)
                            panelText.subGetScript = function(command)
                                local comOutput = io.popen(command)
                                local comData = comOutput:read("*all")
                                comOutput:close()
                                
                                return comData
                            end
                            
                        end
                       )
