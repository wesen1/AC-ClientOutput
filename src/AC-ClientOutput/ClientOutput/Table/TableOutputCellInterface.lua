---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

local TableOutputCellInterface = Object:extend()



---
-- Returns the tab stop number of the next tab stop after this ClientOutput's content.
--
-- @treturn int The tab stop number
--
function BaseClientOutput:getContentEndTabStopNumber()
end

---
-- Returns the minimum number of tabs that this client output's content requires.
--
-- @treturn int The minimum number of required tabs
--
function BaseClientOutput:getMinimumNumberOfRequiredTabs()
end

---
-- Returns the output rows padded with tabs until the configured maxmimum number of tabs.
--
-- @treturn string[] The output rows padded with tabs
--
function BaseClientOutput:getOutputRowsPaddedWithTabs()
end


return TableOutputCellInterface
