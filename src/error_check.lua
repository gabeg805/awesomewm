-- 
-- CREATED BY: Gabriel Gonzalez (contact me at gabeg@bu.edu)
-- 
-- 
-- NAME:
-- 	
--     error_check.lua
-- 
-- 
-- SYNTAX: 
-- 	
--     dofile("/PATH/TO/FILE/error_check.lua")
-- 
-- 
-- PURPOSE:
-- 	
--     Checks for errors on compile.
-- 
-- 
-- KEYWORDS:
-- 	
--     N/A
-- 
-- 
-- FUNCTIONS:
-- 	
--     N/A
-- 
-- 
--  FILE STRUCTURE:
--
--     * Check For Errors On Compile
-- 
-- 
-- MODIFICATION HISTORY:
-- 	
--     gabeg Mar 08 2014 <> created
--
-- **********************************************************************************



-- ---------------------------------------
-- ----- CHECK FOR ERRORS ON COMPILE -----
-- ---------------------------------------

-- Check if awesome encountered an error during startup and fell back to another config
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end


-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal(
        "debug::error", 
        function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true
            
            naughty.notify({ preset = naughty.config.presets.critical,
                             title = "Oops, an error happened!",
                             text = err })
            in_error = false
        end)
end
