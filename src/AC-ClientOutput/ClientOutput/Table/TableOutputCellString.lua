---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TableOutputCellString = Object:extend()



---
-- Returns the number of tabs that this client output's content requires.
--
-- @treturn int The number of required tabs
--
function ClientOutputString:getNumberOfRequiredTabs()
  self.stringWidthCalculator:reset()
  local stringWidth = self.stringWidthCalculator:getStringWidth(self.string)

  return self.tabStopCalculator:getNextTabStopNumber(stringWidth)
end

---
-- Returns the minimum number of tabs that this client output's content requires.
--
-- @treturn int The minimum number of required tabs
--
function ClientOutputString:getMinimumNumberOfRequiredTabs()
  return 1
end

---
-- Returns the output rows padded with tabs until the configured maxmimum number of tabs.
--
-- @treturn string[] The output rows padded with tabs
--
function ClientOutputString:getOutputRowsPaddedWithTabs()
  return self.splitter:getRows(self.configuration:getMaximumNumberOfTabs())
end



return TableOutputCellString
