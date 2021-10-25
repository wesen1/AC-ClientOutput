---
-- @author wesen
-- @copyright 2018-2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Provides methods to calculate tab stop positions and distances to tab stops.
--
-- @type TabStopCalculator
--
local TabStopCalculator = Object:extend()


---
-- The width of one tab in pixels
--
-- @tfield int tabWidth
--
TabStopCalculator.tabWidth = nil


-- Metamethods

---
-- TabStopCalculator constructor.
--
-- @tparam int _tabWidth The width of one tab in pixels
--
function TabStopCalculator:new(_tabWidth)
  self.tabWidth = _tabWidth
end


-- Public Methods

---
-- Returns the number of passed tab stops at a specific text pixel position.
--
-- @tparam int _textPixelPosition The pixel position inside the output text
--
-- @treturn int The number of passed tab stops
--
function TabStopCalculator:getNumberOfPassedTabStops(_textPixelPosition)
  return math.floor(_textPixelPosition / self.tabWidth)
end

---
-- Returns the number of tab stops between a text pixel position and a tab stop number.
--
-- @tparam int _textPixelPosition The pixel position inside the output text
-- @tparam int _tabStopNumber The tab stop number
--
-- @treturn int The number of tab stops between the position and the tab stop
--
function TabStopCalculator:getNumberOfTabsToTabStop(_textPixelPosition, _tabStopNumber)
  return _tabStopNumber - self:getNumberOfPassedTabStops(_textPixelPosition)
end

---
-- Returns the number of the tab stop that follows a specific text pixel position.
--
-- @tparam int _textPixelPosition The pixel position inside the output text
--
-- @treturn int The next tab stop number
--
function TabStopCalculator:getNextTabStopNumber(_textPixelPosition)
  return self:getNumberOfPassedTabStops(_textPixelPosition) + 1
end

---
-- Returns the next tab stop position for a specific text pixel position.
--
-- @tparam int _textPixelPosition The pixel position inside the output text
--
-- @treturn int The next tab stop position in pixels
--
function TabStopCalculator:getNextTabStopPosition(_textPixelPosition)
  return self:convertTabNumberToPosition(self:getNextTabStopNumber(_textPixelPosition))
end

---
-- Converts a tab number to a pixel position.
--
-- @tparam int _tabNumber The tab number
--
-- @treturn int The corresponding pixel position
--
function TabStopCalculator:convertTabNumberToPosition(_tabNumber)
  return _tabNumber * self.tabWidth
end


return TabStopCalculator
