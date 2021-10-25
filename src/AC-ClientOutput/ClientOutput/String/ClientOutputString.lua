---
-- @author wesen
-- @copyright 2019-2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local ClientOutputBase = require "AC-ClientOutput.ClientOutput.ClientOutputBase"

---
-- Converts strings into output rows.
--
-- @type ClientOutputString
--
local ClientOutputString = ClientOutputBase:extend()

---
-- The InputStringParser that will be used to parse raw input strings into input lines
--
-- @tfield InputStringParser parser
--
ClientOutputString.parser = nil

--
-- The LineSplitter that will be used to split the parsed input lines into output rows
--
-- @tfield LineSplitter lineSplitter
--
ClientOutputString.outputRowGenerator = nil


---
-- ClientOutputString constructor.
--
-- @tparam Parser _parser The parser to use
-- @tparam InputLineSplitter _lineSplitter The LineSplitter to use
--
function ClientOutputString:new(_parser, _lineSplitter)
  ClientOutputBase.new(self)
  self.parser = _parser
  self.inputLineSplitter = _lineSplitter
end


-- Public Methods

---
-- Parses a input string into this ClientOutputString.
-- This is the input string split into lines by "\n"
--
-- @tparam string _string The input string to parse
--
function ClientOutputString:doParse(_string)
  return self.parser:parse(_string)
end

---
-- Generates and returns the output rows for the current parsed string.
--
-- @treturn string[] The output rows
--
function ClientOutputString:doGenerateOutputRows(_inputLines)

  local outputRows = {}
  for _, inputLine in ipairs(_inputLines) do
    for _, outputRow in ipairs(self.inputLineSplitter:splitIntoOutputRows(inputLine)) do
      table.insert(outputRows, outputRow)
    end
  end

  return outputRows

end


return ClientOutputString
