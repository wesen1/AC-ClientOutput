---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Base = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubStringPosition.Finder.Base"

---
-- Finds all color substrings in given lines.
--
-- @type Color
--
local Color = Base:extend()

Color.IDENTIFIER = "colors"

---
-- Color constructor.
--
function Color:new()
  Base.new(self, Color.IDENTIFIER)
end


-- Public Methods

---
-- Finds and returns all positions of this Finder's target substring in a given line.
--
-- @tparam string _line The line to search for substrings
--
-- @treturn Position[] The substring positions that were found in the line
--
function Color:findPositionsInLine(_line)
  return self:findPositionsByPattern(_line, "\f[%a%d]")
end


return Color
