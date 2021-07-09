---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Base = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubStringPosition.Finder.Base"

---
-- Finds all whitespace substrings in given lines.
--
-- @type Whitespace
--
local Whitespace = Base:extend()

Whitespace.IDENTIFIER = "whitespace"

---
-- Whitespace constructor.
--
function Whitespace:new()
  Base.new(self, Whitespace.IDENTIFIER)
end


-- Public Methods

---
-- Finds and returns all positions of this Finder's target substring in a given line.
--
-- @tparam string _line The line to search for substrings
--
-- @treturn Position[] The substring positions that were found in the line
--
function Whitespace:findPositionsInLine(_line)
  return self:getPositionsByPattern(_line, "%s+")
end


return Whitespace
