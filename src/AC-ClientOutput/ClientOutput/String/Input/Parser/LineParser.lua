---
-- @author wesen
-- @copyright 2019-2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local List = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.List"
local ListCollection = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.ListCollection"
local ParsedLine = require "AC-ClientOutput.ClientOutput.String.Input.Parser.ParsedLine"

---
-- Creates ParsedLine's from given raw lines.
--
-- @type LineParser
--
local LineParser = Object:extend()

---
-- The substring position finders that will be used to find substring positions in raw lines
--
-- @tfield SubstringPosition.Finder.Base[] substringPositionFinders
--
LineParser.substringPositionFinders = {}


---
-- LineParser constructor.
--
-- @tparam SubstringPosition.Finder.Base[] _substringPositionFinders The substring position finders to use
--
function LineParser:new(_substringPositionFinders)
  self.substringPositionFinders = _substringPositionFinders
end


-- Public Methods

---
-- Parses a raw line and returns a ParsedLine instance.
--
-- @tparam string _line The raw line to parse
--
-- @treturn ParsedLine The parsed line
--
function LineParser:parse(_line)

  local substringPositionListCollection = ListCollection(List({}))
  for _, substringPositionFinder in ipairs(self.substringPositionFinders) do
    substringPositionListCollection:addSubstringPositionList(
      substringPositionFinder:getIdentifier(),
      List(substringPositionFinder:findPositionsInLine(_line))
    )
  end

  return ParsedLine(_line, substringPositionListCollection)

end


return LineParser
