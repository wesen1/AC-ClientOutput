---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains a list of substring positions and provides methods to fetch information about the positions.
--
-- @type List
--
local List = Object:extend()

---
-- The list of substring positions
--
-- @tfield Position[] substringPositions
--
List.substringPositions = nil


---
-- List constructor.
--
-- @tparam Position[] _substringPositions The list of substring positions
--
function List:new(_substringPositions)
  self.substringPositions = _substringPositions
end


-- Public Methods

---
-- Returns whether one of the substring positions contains a specific string position.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if one of the substring positions contains the given string position, false otherwise
--
function List:containsSubstringAt(_stringPosition)
  return (self:getSubstringPositionThatContains(_stringPosition) ~= nil)
end

---
-- Returns whether a specific string position is at the start or end position of one of the substring positions.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if the given string position is at the start or end of one of the substring positions, false otherwise
--
function List:isSubstringStartOrEndPosition(_stringPosition)

  local substringPosition = self:getSubstringPositionThatContains(_stringPosition)
  if (substringPosition) then
    return substringPosition:isStartOrEndPosition(_stringPosition)
  else
    return false
  end

end

---
-- Returns the last substring position before a given string position.
--
-- @tparam int _stringPosition The string position
--
-- @treturn Position|nil The last substring position before the given string position or nil if none was found before that string position
--
function List:getLastSubstringPositionBefore(_stringPosition)

  for _, substringPosition in ipairs(self.substringPositions) do
    if (substringPosition:endsBeforePosition(_stringPosition)) then
      return substringPosition
    end
  end

end

---
-- Returns the first next string position that is not contained in any substring position after a given string position.
-- The result can be greater than the string length.
--
-- @tparam int _stringPosition The string position
--
-- @treturn int The next string position that is not contained in any substring position after the given string position
--
function List:getNextUncontainedStringPositionAfter(_stringPosition)

  local nextPosition = _stringPosition + 1
  local substringPosition

  repeat

    substringPosition = self:getSubstringPositionThatContains(nextPosition)
    if (substringPosition) then
      nextPosition = substringPosition:getEndPosition() + 1
    end

  until (substringPosition == nil)

  return nextPosition:getEndPosition() + 1

end

---
-- Returns the first previous string position that is not contained in any substring position before a given string position.
-- The result can be smaller than 1.
--
-- @tparam int _stringPosition The string position
--
-- @treturn int The previous string position that is not contained in any substring position before the given string position
--
function List:getLastUncontainedStringPositionBefore(_stringPosition)

  local previousPosition = _stringPosition - 1
  local substringPosition

  repeat

    substringPosition = self:getSubstringPositionThatContains(previousPosition)
    if (substringPosition) then
      previousPosition = substringPosition:getStartPosition() -1
    end

  until (substringPosition == nil)

  return previousPosition

end


-- Private Methods

---
-- Returns the substring position that contains a given string position.
--
-- @tparam int _stringPosition The string position
--
-- @treturn Position|nil The substring position that contains the given string position or nil if no substring position contains the string position
--
function List:getSubstringPositionThatContains(_stringPosition)

  for _, substringPosition in ipairs(self.substringPositions) do
    if (substringPosition:containsPosition(_stringPosition)) then
      return substringPosition
    end
  end

end


return List
