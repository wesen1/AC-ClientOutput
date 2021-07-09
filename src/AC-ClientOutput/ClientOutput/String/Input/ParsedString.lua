---
-- @author wesen
-- @copyright 2019-2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains the parse results for a raw input string and provides methods to fetch parsed lines.
--
-- @type ParsedString
--
local ParsedString = Object:extend()

---
-- The parsed lines
--
-- @tfield ParsedLine[] parsedLines
--
ParsedString.parsedLines = nil


---
-- ParsedString constructor.
--
-- @tparam ParsedLine[] _parsedLines The parsed lines
--
function ParsedString:new(_parsedLines)
  self.parsedLines = _parsedLines
end


-- Getters and Setters

---
-- Returns the parsed lines.
--
-- @treturn ParsedLine[] The parsed lines
--
function ParsedString:getParsedLines()
  return self.parsedLines
end


return ParsedString
