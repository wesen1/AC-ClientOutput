---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Base = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubStringPosition.Finder.Base"

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
-- @tparam string _searchCharacters The characters to search for (Default: ".")
--
function Custom:new(_identifier, _searchCharacters)
  Custom.new(self, _identifier)
  self.searchCharacters = _searchCharacters or "."
end


-- Public Methods

---
-- Finds and returns all positions of this Finder's target substring in a given line.
--
-- @tparam string _line The line to search for substrings
--
-- @treturn Position[] The substring positions that were found in the line
--
function Custom:getPositionsInLine(_line)
  return self:getPositionsByPattern(_line, "[^\f]([" .. self.searchCharacters .. "]+)")
end


return Custom
