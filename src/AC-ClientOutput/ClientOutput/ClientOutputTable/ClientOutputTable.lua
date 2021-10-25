---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseClientOutput = require("AC-ClientOutput/ClientOutput/BaseClientOutput")
local TableRenderer = require("AC-ClientOutput/ClientOutput/ClientOutputTable/TableRenderer")
local TableParser = require("AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/TableParser")

---
-- Represents a output table for the console in the players games.
--
-- @type ClientOutputTable
--
local ClientOutputTable = {}


---
-- The table parser
--
-- @tfield TableParser parser
--
ClientOutputTable.parser = nil

---
-- The current parsed table
--
-- @tfield ParsedTable|nil parsedTable
--
ClientOutputTable.parsedTable = nil

---
-- The renderer for this ClientOutputTable
--
-- @tfield TableRenderer renderer
--
ClientOutputTable.renderer = nil


-- Metamethods

---
-- ClientOutputTable constructor.
-- This is the __call metamethod.
--
-- @tparam SymbolWidthLoader _symbolWidthLoader The symbol width loader
-- @tparam TabStopCalculator _tabStopCalculator The tab stop calculator
-- @tparam ClientOutputTableConfiguration _configuration The configuration
--
-- @treturn ClientOutputTable The ClientOutputTable instance
--
function ClientOutputTable:__construct(_symbolWidthLoader, _tabStopCalculator, _configuration)
  local instance = BaseClientOutput(_configuration)
  setmetatable(instance, {__index = ClientOutputTable})

  instance.parser = TableParser(_symbolWidthLoader, _tabStopCalculator)
  instance.renderer = TableRenderer()

  return instance
end


-- Public Methods

---
-- Parses a table.
--
-- @tparam table _table The table to parse
--
function ClientOutputTable:parse(_table)
  self.parsedTable = self.parser:parse(_table, self.configuration)
end

---
-- Returns the number of tabs that this client output's content requires.
--
-- @treturn int The number of required tabs
--
function ClientOutputTable:getNumberOfRequiredTabs()

  if (self.parsedTable) then
    return self.parsedTable:getTotalNumberOfRequiredTabs(false)
  else
    return 0
  end

end

---
-- Returns the minimum number of tabs that this client output's content requires.
--
-- @treturn int The minimum number of required tabs
--
function ClientOutputTable:getMinimumNumberOfRequiredTabs()

  if (self.parsedTable) then
    return self.parsedTable:getTotalNumberOfRequiredTabs(true)
  else
    return 0
  end

end

---
-- Returns the output rows to display this client output's contents.
--
-- @treturn string[] The output rows
--
function ClientOutputTable:getOutputRows()
  return self.renderer:getOutputRows(self.parsedTable, self.configuration:getMaximumNumberOfTabs(), false)
end

---
-- Returns the output rows padded with tabs until a specified tab number.
--
-- @tparam int _tabNumber The tab number
--
-- @treturn string[] The output rows padded with tabs
--
function ClientOutputTable:getOutputRowsPaddedWithTabs(_tabNumber)
  return self.renderer:getOutputRows(self.parsedTable, _tabNumber, true)
end


setmetatable(
  ClientOutputTable,
  {
    -- ClientOutputTable inherits methods and attributes from BaseClientOutput
    __index = BaseClientOutput,

    -- When ClientOutputTable() is called, call the __construct method
    __call = ClientOutputTable.__construct
  }
)


return ClientOutputTable
