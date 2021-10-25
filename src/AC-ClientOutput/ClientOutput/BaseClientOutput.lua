---
-- @author wesen
-- @copyright 2019-2021 wesen <wesen-ac@web.de>
-- @release 1.0
-- @license MIT
--

local NoStringParsedException = require "AC-ClientOutput.ClientOutput.String.Exception.NoStringParsed"
local Object = require "classic"

---
-- Base class for ClientOutput's.
-- ClientOutput's take inputs (for example strings or tables) and convert them to a set of output rows
-- that should be sent to AC clients to display the input.
--
-- This class defines a few methods that child classes must implement.
--
-- Call ClientOutputBase::parse() to parse an input into the ClientOutput.
-- Then call ClientOutputBase::getOutputRows() to convert the parsed input to output rows for a given font.
--
-- @type ClientOutputBase
--
local ClientOutputBase = Object:extend()

---
-- The parsed input that was created from the input given to ClientOutputBase:parse()
--
-- @tfield mixed parsedInput
--
ClientOutputBase.parsedInput = nil


-- Public Methods

---
-- Parses an input into this ClientOutput.
-- A input can be a string or a table for example.
--
-- @tparam mixed _input The input
--
function ClientOutputBase:parse(_input)

  if (self.parsedInput ~= nil) then
    error(AlreadyParsedInputException())
  end

  self.parsedInput = self:doParse(_input)

end

---
-- Generates and returns the output rows for the current parsed input.
--
-- @treturn string[] The generated output rows
--
function ClientOutputBase:getOutputRows()

  if (self.parsedInput == nil) then
    error(NoInputParsedException())
  end

  return self:doGenerateOutputRows(self.parsedInput)

end


-- Protected Methods

---
-- Parses a given input and returns the parsed input.
--
-- @tparam mixed _input The input to parse
--
-- @treturn mixed The parsed input
--
function ClientOutputBase:doParse(_input)
end

---
-- Generates output rows from the given parsed input.
--
-- @tparam mixed _parsedInput The parsed input to generate output rows from
--
-- @treturn string[] The generated output rows
--
function ClientOutputBase:doGenerateOutputRows(_parsedInput)
end


return ClientOutputBase
