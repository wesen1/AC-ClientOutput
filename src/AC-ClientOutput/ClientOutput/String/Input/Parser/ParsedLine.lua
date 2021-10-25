---
-- @author wesen
-- @copyright 2019-2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Color = require "AC-ClientOutput.ClientOutput.ClientOutputString.Input.Parser.SubstringPosition.Finder.Color"
local Object = require "classic"
local Whitespace = require "AC-ClientOutput.ClientOutput.ClientOutputString.Input.Parser.SubstringPosition.Finder.Whitespace"

---
-- Contains the parse results for a single raw line and provides methods to fetch parsed information.
--
-- @type ParsedLine
--
local ParsedLine = Object:extend()

---
-- The raw line
--
-- @tfield string line
--
ParsedLine.line = nil

---
-- The substring position list collection
--
-- @tfield Collection substringPositionListCollection
--
ParsedLine.substringPositionListCollection = nil


---
-- ParsedLine constructor.
--
-- @tparam string _line The raw line
-- @tparam Collection _substringPositionListCollection The substring position list collection
--
function ParsedLine:new(_line, _subStringPositionListCollection)
  self.line = _line
  self.substringPositionListCollection = _subStringPositionListCollection
end


-- Getters and Setters

---
-- Returns the raw line.
--
-- @treturn string The raw line
--
function ParsedLine:getLine()
  return self.line
end


-- Public Methods

---
-- Returns whether a string position is a color position.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if the given string position is a color position, false otherwise
--
function ParsedLine:isColorPosition(_stringPosition)

  return self.substringPositionListCollection
             :getSubstringPositionList(Color.IDENTIFIER)
             :containsSubstringAt(_stringPosition)

end

---
-- Returns whether a string position is a line split character position.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if the given string position is a line split character position, false otherwise
--
function ParsedLine:isLineSplitCharacterPosition(_stringPosition)

  return self.substringPositionListCollection
             :getSubstringPositionList("lineSplitCharacters")
             :containsSubstringAt(_stringPosition)

end

---
-- Returns whether a string position is a start or end position of a whitespace substring.
--
-- @tparam int _stringPosition The string position to check
--
-- @treturn bool True if the position is a whitespace substring start or end position, false otherwise
--
function ParsedLine:isWhitespaceStartOrEndPosition(_stringPosition)

  return self.substringPositionListCollection
             :getSubstringPositionList(Whitespace.IDENTIFIER)
             :isSubstringStartOrEndPosition(_stringPosition)

end

---
-- Returns the last color before a specified string position.
--
-- @tparam int _stringPosition The string position
--
-- @treturn string|nil The color string or nil if no color was found before the string position
--
function ParsedLine:getLastColorBefore(_stringPosition)

  local substringPosition = self.substringPositionListCollection
                                :getSubstringPositionList(Color.IDENTIFIER)
                                :getLastSubstringPositionBefore(_stringPosition)

  if (substringPosition) then
    -- Return only the color code and omit the preceding "\f"
    return self.line:sub(substringPosition:getEndPosition(), substringPosition:getEndPosition())
  end

end

---
-- Returns the last line split character position before a specified string position.
--
-- @tparam int _stringPosition The string position
--
-- @treturn int|nil The last line split character position or nil if there is no line split character before the given string position
--
function ParsedLine:getLastLineSplitCharacterPositionBefore(_stringPosition)

  local stringPosition = self.substringPositionListCollection
                             :getSubstringPositionList("lineSplitCharacters")
                             :getLastUncontainedStringPositionBefore(_stringPosition)

  return stringPosition + 1

  -- TODO: Fix this method
  if (substringPosition) then
    return substringPosition:getEndPosition()
  end

end

---
-- Returns the next string position that is not inside a whitespace substring relative to a specified string position.
--
-- @tparam int _stringPosition The string position
--
-- @treturn int The next non whitespace substring position after the given string position
--
function ParsedLine:getNextNonWhitespacePositionAfter(_stringPosition)

  return self.substringPositionListCollection
             :getSubstringPositionList(Whitespace.IDENTIFIER)
             :getNextUncontainedStringPositionAfter(_stringPosition)

end

---
-- Returns the last string position that is not inside a whitespace substring relative to a specified string position.
--
-- @tparam int _stringPosition The string position
--
-- @treturn int The last non whitespace substring position before the given string position
--
function ParsedLine:getLastNonWhitespacePositionBefore(_stringPosition)

  return self.substringPositionListCollection
             :getSubstringPositionList(Whitespace.IDENTIFIER)
             :getLastUncontainedStringPositionBefore(_stringPosition)

end


return ParsedLine
