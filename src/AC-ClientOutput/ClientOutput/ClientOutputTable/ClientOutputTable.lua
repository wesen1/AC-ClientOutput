---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseClientOutput = require("AC-ClientOutput/ClientOutput/BaseClientOutput")
local ClientOutputTableRenderer = require("AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTableRenderer")

---
-- Represents a output table for the console in the players games.
--
-- @type ClientOutputTable
--
local ClientOutputTable = {}


---
-- The rows inside this table that were parsed from a lua table
--
-- @tfield table[] rows
--
ClientOutputTable.rows = nil

---
-- The renderer for this ClientOutputTable
--
-- @tfield ClientOutputTableRenderer renderer
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

  instance.renderer = ClientOutputTableRenderer(instance)

  return instance

end


-- Getters and Setters

---
-- Returns the rows of this ClientOutputTable.
--
-- @treturn table[] The rows
--
function ClientOutputTable:getRows()
  return self.rows
end


-- Public Methods

---
-- Parses a table.
-- The table must be in the format { [y] = { rowFields } }, while a row field may contain a sub table.
-- Every row must have the same number of columns.
--
-- @tparam table _table The table to parse
--
function ClientOutputTable:parse(_table)

  local ClientOutputFactory = require("AC-ClientOutput/ClientOutputFactory")

  self.rows = {}
  for y, row in ipairs(_table) do

    self.rows[y] = {}

    if (type(row) ~= "table") then
      self.rows[y][1] = ClientOutputFactory.getInstance():getClientOutputString(row)
      self.rows[y][1]:configure(self.configuration:getConfigurationForField(y, 1, false))
    else

      for x, field in ipairs(row) do

        if (type(field) == "table") then
          self.rows[y][x] = ClientOutputFactory.getInstance():getClientOutputTable(field)
          self.rows[y][x]:configure(self.configuration:getConfigurationForField(y, x, true))
        else
          self.rows[y][x] = ClientOutputFactory.getInstance():getClientOutputString(tostring(field))
          self.rows[y][x]:configure(self.configuration:getConfigurationForField(y, x, false))
        end

      end

    end
  end

end

---
-- Returns the number of tabs that this client output's content requires.
--
-- @treturn int The number of required tabs
--
function ClientOutputTable:getNumberOfRequiredTabs()

  local numberOfRequiredTabs = 0
  for x = 1, self:getNumberOfColumns(), 1 do
    numberOfRequiredTabs = numberOfRequiredTabs + self:getNumberOfRequiredTabsForColumn(x)
  end

  return numberOfRequiredTabs

end

---
-- Returns the minimum number of tabs that this client output's content requires.
--
-- @treturn int The minimum number of required tabs
--
function ClientOutputTable:getMinimumNumberOfRequiredTabs()

  local minimumNumberOfRequiredTabs = 0
  for x = 1, self:getNumberOfColumns(), 1 do
    minimumNumberOfRequiredTabs = minimumNumberOfRequiredTabs + self:getMinimumNumberOfRequiredTabsForColumn(x)
  end

  return minimumNumberOfRequiredTabs

end

---
-- Returns the output rows to display this client output's contents.
--
-- @treturn string[] The output rows
--
function ClientOutputTable:getOutputRows()
  return self.renderer:getOutputRows()
end

---
-- Returns the output rows padded with tabs until a specified tab number.
--
-- @tparam int _tabNumber The tab number
--
-- @treturn string[] The output rows padded with tabs
--
function ClientOutputTable:getOutputRowsPaddedWithTabs(_tabNumber)
  return self.renderer:getOutputRows(_tabNumber)
end


---
-- Returns the required number of tabs for a specific column.
--
-- @tparam int _columnNumber The column number
--
-- @treturn int The required number of tabs for the column
--
function ClientOutputTable:getNumberOfRequiredTabsForColumn(_columnNumber)

  if (_columnNumber > self:getNumberOfColumns()) then
    return 0
  end

  local numberOfRequiredTabs = 0
  for _, row in ipairs(self.rows) do

    local numberOfRequiredTabsForField = row[_columnNumber]:getNumberOfRequiredTabs()
    if (numberOfRequiredTabsForField > numberOfRequiredTabs) then
      numberOfRequiredTabs = numberOfRequiredTabsForField
    end

  end

  return numberOfRequiredTabs

end

---
-- Returns the minimun required number tabs for a specific column.
--
-- @tparam int _columnNumber The column number
--
-- @treturn int The minimum required number of tabs for the column
--
function ClientOutputTable:getMinimumNumberOfRequiredTabsForColumn(_columnNumber)

  if (_columnNumber > self:getNumberOfColumns()) then
    return 0
  end

  local minimumNumberOfRequiredTabs = 0
  for _, row in ipairs(self.rows) do

    local minimumNumberOfRequiredTabsForField = row[_columnNumber]:getMinimumNumberOfRequiredTabs()
    if (minimumNumberOfRequiredTabsForField > minimumNumberOfRequiredTabs) then
      minimumNumberOfRequiredTabs = minimumNumberOfRequiredTabsForField
    end

  end

  return minimumNumberOfRequiredTabs

end

---
-- Returns the number of columns in this table.
--
-- @treturn int The number of columns in this table
--
function ClientOutputTable:getNumberOfColumns()

  if (#self.rows == 0) then
    return 0
  else
    return #self.rows[1]
  end

end
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
