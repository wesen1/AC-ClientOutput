---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Represents a substring position inside a line.
--
-- @type Position
--
local Position = Object:extend()

---
-- The start position of the substring
--
-- @tfield int startPosition
--
Position.startPosition = nil

---
-- The end position of the substring
--
-- @tfield int endPosition
--
Position.endPosition = nil

---
-- Position constructor.
--
-- @tparam int _startPosition The start position of the substring
-- @tparam int _endPosition The end position of the substring
--
function Position:new(_startPosition, _endPosition)
  self.startPosition = _startPosition
  self.endPosition = _endPosition
end


-- Getters and Setters

---
-- Returns the start position of the substring.
--
-- @treturn int The start position of the substring
--
function Position:getStartPosition()
  return self.startPosition
end

---
-- Returns the end position of the substring.
--
-- @treturn int The end position of the substring
--
function Position:getEndPosition()
  return self.endPosition
end


-- Public Methods

---
-- Returns whether this substring position starts after a given position.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if this substring position starts after the given string position, false otherwise
--
function Position:startsAfterPosition(_stringPosition)
  return self.startPosition > _stringPosition
end

---
-- Returns whether this substring position ends before a given position.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if this substring position ends before a given string position, false otherwise
--
function Position:endsBeforePosition(_stringPosition)
  return self.endPosition < _stringPosition
end

---
-- Returns whether this substring position contains a given position.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if this substring position contains the given string position, false otherwise
--
function Position:containsPosition(_stringPosition)
  return (self.startPosition <= _stringPosition and self.endPosition >= _stringPosition)
end

---
-- Returns whether a given position matches this substring positions start or end position.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if the given position matches this substring positions start or end position, false otherwise
--
function Position:isStartOrEndPosition(_stringPosition)
  return (self.startPosition == _stringPosition or self.endPosition == _stringPosition)
end


return Position
