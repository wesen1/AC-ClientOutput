---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Position = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Position"
local Object = require "classic"

---
-- Base class for substring position finders.
--
-- @type Base
--
local Base = Object:extend()

---
-- The unique identifier of this substring position finder
--
-- @tfield string identifier
--
Base.identifier = nil


---
-- Base constructor.
--
-- @tparam string _identifier The unique identifier of the substring position finder
--
function Base:new(_identifier)
  self.identifier = _identifier
end


-- Getters and Setters

---
-- Returns the unique identifier of this substring position finder.
--
-- @treturn string The unique identifier of this substring position finder
--
function Base:getIdentifier()
  return self.identifier
end


-- Public Methods

---
-- Finds and returns all positions of this Finder's target substring in a given line.
--
-- @tparam string _line The line to search for substrings
--
-- @treturn Position[] The substring positions that were found in the line
--
function Base:findPositionsInLine(_line)
end


-- Protected Methods

---
-- Finds and returns all positions of a pattern in a given line.
--
-- @tparam string _line The line to search for positions of a pattern
-- @tparam string _pattern The pattern to search the line for
--
-- @treturn Position[] The pattern positions that were found in the line
--
function Base:findPositionsByPattern(_line, _pattern)

  local positions = {}

  local startPosition, endPosition, searchOffset
  repeat
    startPosition, endPosition = _line:find(_pattern, searchOffset)
    if (startPosition ~= nil) then
      table.insert(positions, Position(startPosition, endPosition))
      searchOffset = endPosition + 1
    end
  until (startPosition == nil)

  return positions

end


return Base
