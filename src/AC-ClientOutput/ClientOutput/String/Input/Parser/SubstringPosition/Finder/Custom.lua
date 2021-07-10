---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Base = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Finder.Base"
local Position = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Position"

---
-- Finds all substrings that contain specific characters in given lines.
--
-- @type Custom
--
local Custom = Base:extend()

---
-- The characters to search for
-- This should be a char-set compatible list of allowed characters
--
-- @tfield string searchCharacters
--
Custom.searchCharacters = nil


---
-- Custom constructor.
--
-- @tparam string _identifier The unique identifier of the substring position finder
-- @tparam string _searchCharacters The characters to search for
--
function Custom:new(_identifier, _searchCharacters)
  Base.new(self, _identifier)
  self.searchCharacters = _searchCharacters
end


-- Public Methods

---
-- Finds and returns all positions of this Finder's target substring in a given line.
--
-- @tparam string _line The line to search for substrings
--
-- @treturn Position[] The substring positions that were found in the line
--
function Custom:findPositionsInLine(_line)

  return self:findPositionsByPattern(
    _line,
    "\f?[" .. self.searchCharacters .. "]+",
    function(_position)

      if (_line:sub(_position:getStartPosition(), _position:getStartPosition()) == "\f") then
        local startPosition = _position:getStartPosition() + 2
        local endPosition = _position:getEndPosition()

        if (startPosition <= endPosition) then
          return Position(startPosition, endPosition)
        end

      else
        return _position
      end
    end
  )

end


return Custom
