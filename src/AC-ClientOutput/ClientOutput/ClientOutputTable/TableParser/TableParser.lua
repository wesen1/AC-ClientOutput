---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local ClientOutputString = require("AC-ClientOutput/ClientOutput/ClientOutputString/ClientOutputString")
local ParsedTable = require("AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/ParsedTable")

---
-- Parses tables for ClientOutputTable's.
--
-- @type TableParser
--
local TableParser = {}


---
-- The symbol width loader
--
-- @tfield SymbolWidthLoader symbolWidthLoader
--
TableParser.symbolWidthLoader = nil

---
-- The tab stop calculator
--
-- @tfield TabStopCalculator tabStopCalculator
--
TableParser.tabStopCalculator = nil


-- Metamethods

---
-- TableParser constructor.
-- This is the __call metamethod.
--
-- @tparam SymbolWidthLoader _symbolWidthLoader The symbol width loader
-- @tparam TabStopCalculator _tabStopCalculator The tab stop calculator
--
-- @treturn TableParser The TableParser instance
--
function TableParser:__construct(_symbolWidthLoader, _tabStopCalculator)
  local instance = setmetatable({}, {__index = TableParser})
  instance.symbolWidthLoader = _symbolWidthLoader
  instance.tabStopCalculator = _tabStopCalculator

  return instance
end


-- Public Methods

---
-- Parses a table and returns a ParsedTable object.
-- The table must be in the format { [y] = { rowFields } }, while a row field may contain a sub table.
-- Every row must have the same number of columns.
--
-- @tparam table _table The table to parse
-- @tparam ClientOutputTableConfiguration _configuration The table configuration
--
-- @treturn ParsedTable The parsed table
--
function TableParser:parse(_table, _configuration)

  local parsedTable = ParsedTable()

  for y, row in ipairs(_table) do

    parsedTable:addRow()
    if (type(row) == "table") then

      -- Iterate over all fields of the row
      for x, field in ipairs(row) do
        if (type(field) == "table") then
          parsedTable:addRowField(self:createClientOutputTableForField(y, x, _configuration, field))
        else
          parsedTable:addRowField(self:createClientOutputStringForField(y, x, _configuration, field))
        end
      end

    else
      -- Create a ClientOutputString for the row content
      parsedTable:addRowField(self:createClientOutputStringForField(y, 1, _configuration, row))
    end
  end

  return parsedTable

end


-- Private Methods

---
-- Creates and returns a ClientOutputString for a specified field.
--
-- @tparam int y The row number of the field
-- @tparam int x The column number of the field
-- @tparam ClientOutputTableConfiguration _configuration The table configuration
-- @tparam mixed _field The field's content
--
-- @treturn ClientOutputString The ClientOutputString for the field
--
function TableParser:createClientOutputStringForField(y, x, _configuration, _field)

  local clientOutputString = ClientOutputString(
    self.symbolWidthLoader, self.tabStopCalculator, _configuration:getConfigurationForField(y, x, false)
  )
  clientOutputString:parse(tostring(_field))

  return clientOutputString

end

---
-- Creates and returns a ClientOutputTable for a specified field.
--
-- @tparam int y The row number of the field
-- @tparam int x The column number of the field
-- @tparam ClientOutputTableConfiguration _configuration The table configuration
-- @tparam table _field The field's content
--
-- @treturn ClientOutputTable The ClientOutputTable for the field
--
function TableParser:createClientOutputTableForField(y, x, _configuration, _field)

  local ClientOutputTable = require("AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTable")

  local clientOutputTable = ClientOutputTable(
    self.symbolWidthLoader, self.tabStopCalculator, _configuration:getConfigurationForField(y, x, true)
  )
  clientOutputTable:parse(_field)

  return clientOutputTable

end


-- When TableParser() is called, call the __construct method
setmetatable(TableParser, {__call = TableParser.__construct})


return TableParser
