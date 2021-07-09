---
-- @author wesen
-- @copyright 2019-2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local ParsedString = require "AC-ClientOutput.ClientOutput.String.Input.ParsedString"

---
-- Creates ParsedString's from given raw input strings.
--
-- @type Parser
--
local Parser = Object:extend()

---
-- The line parser
--
-- @tfield LineParser lineParser
--
Parser.lineParser = nil


---
-- Parser constructor.
--
-- @tparam LineParser _lineParser The line parser
--
function Parser:new(_lineParser)
  self.lineParser = _lineParser
end


-- Public Methods

---
-- Parses a raw input string and returns a ParsedString instance.
--
-- @tparam string _string The raw input string to parse
--
-- @treturn ParsedString The parsed string
--
function Parser:parse(_string)

  local parsedLines = {}

  local inputLines = self:splitIntoInputLines(_string)
  for _, inputLine in ipairs(inputLines) do
    table.insert(parsedLines, self.lineParser:parse(inputLine))
  end

  return ParsedString(parsedLines)

end


-- Private Methods

---
-- Splits a given raw input string into raw input lines.
--
-- @tparam string _string The string to split into raw input lines
--
-- @treturn string[] The raw input lines
--
function Parser:splitIntoInputLines(_string)

  local inputLines = {}
  for line in _string:gmatch("\n") do
    table.insert(inputLines, line)
  end

  return inputLines

end


return Parser
