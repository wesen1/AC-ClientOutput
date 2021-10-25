---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

---
-- Contains the parsed table for a ClientOutputTable.
-- Also provides methods to fetch information about the parsed table.
--
-- The intended use is to first add all rows and row fields and then fetch information about the
-- parsed table.
--
-- @type ParsedTable
--
local ParsedTable = {}


---
-- The rows inside this table that were parsed from a user defined table
--
-- @tfield table[] rows
--
ParsedTable.rows = nil

---
-- The curent row number
--
-- @tfield int currentRowNumber
--
ParsedTable.currentRowNumber = nil

---
-- The current field number inside the current row
--
-- @tfield int currentFieldNumber
--
ParsedTable.currentFieldNumber = nil


-- Metamethods

---
-- ParsedTable constructor.
-- This is the __call metamethod.
--
-- @treturn ParsedTable The ParsedTable instance
--
function ParsedTable:__construct()
  local instance = setmetatable({}, {__index = ParsedTable})
  instance.rows = {}
  instance.currentRowNumber = 0
  instance.currentFieldNumber = 0

  return instance
end


-- Getters and Setters

---
-- Returns the parsed rows.
--
-- @treturn table[] The parsed rows
--
function ParsedTable:getRows()
  return self.rows
end


-- Public Methods

---
-- Adds a new row to this ParsedTable.
-- Must be called once before adding the first row field.
--
function ParsedTable:addRow()
  self.currentRowNumber = self.currentRowNumber + 1
  self.currentFieldNumber = 0

  self.rows[self.currentRowNumber] = {}
end

---
-- Adds a new row field to the current row of this ParsedTable.
--
-- @tparam BaseClientOutput _field The field
--
function ParsedTable:addRowField(_field)
  self.currentFieldNumber = self.currentFieldNumber + 1
  self.rows[self.currentRowNumber][self.currentFieldNumber] = _field
end


---
-- Returns the number of columns in this ParsedTable.
--
-- @treturn int The number of columns
--
function ParsedTable:getNumberOfColumns()
  return self.currentFieldNumber
end

---
-- Returns the required number of tabs for a specific column.
--
-- @tparam int _columnNumber The column number
-- @tparam bool _getMinimumNumber If true the minimum number of tabs for the column will be returned
--
-- @treturn int The required number of tabs for the column
--
function ParsedTable:getNumberOfRequiredTabsForColumn(_columnNumber, _getMinimumNumber)

  --[[
  function ClientOutputTable:getNumberOfRequiredTabs(_minimumSpaceBetweenColumns)
    numberOfRequiredTabs = numberOfRequiredTabs + self:getNumberOfRequiredTabsForColumn(x, _minimumSpaceBetweenColumns)

    local numberOfRequiredTabsForField = row[_columnNumber]:getNumberOfRequiredTabs(self.minimumSpaceBetweenFields)

  --]]


  if (_columnNumber > self:getNumberOfColumns()) then
    return 0
  end

  local numberOfRequiredTabs = 0
  for _, row in ipairs(self.rows) do

    local numberOfRequiredTabsForField
    if (_getMinimumNumber) then
      numberOfRequiredTabsForField = row[_columnNumber]:getMinimumNumberOfRequiredTabs()
    else
      numberOfRequiredTabsForField = row[_columnNumber]:getNumberOfRequiredTabs()
    end

    if (numberOfRequiredTabsForField > numberOfRequiredTabs) then
      numberOfRequiredTabs = numberOfRequiredTabsForField
    end

  end

  return numberOfRequiredTabs

end

---
-- Returns the total number of required tabs for all columns of this ParsedTable.
--
-- @tparam bool _getMinimumNumber If true the minimum total number of required tabs will be returned
--
-- @treturn int The total number of required tabs
--
function ParsedTable:getTotalNumberOfRequiredTabs(_getMinimumNumber)

  local numberOfRequiredTabs = 0
  for x = 1, self:getNumberOfColumns(), 1 do
    numberOfRequiredTabs = numberOfRequiredTabs + self:getNumberOfRequiredTabsForColumn(x, _getMinimumNumber)
  end

  return numberOfRequiredTabs

end

---
-- Returns the numbers of tabs per column.
--
-- @tparam int _maxmiumNumberOfTabs The maximum number of tabs for the entire table (optional)
--
-- @treturn int[] The numbers of tabs per column
--
-- @raise Error when the table does not fit into the maximum number of tabs
--
function ParsedTable:getNumberOfTabsPerColumn(_maxmiumNumberOfTabs)

  local numberOfColumns = self:getNumberOfColumns()

  local remainingNumberOfTabs
  if (_maxmiumNumberOfTabs == nil) then
    -- Set the remaining number of tabs to infinity
    remainingNumberOfTabs = math.huge()
  else
    remainingNumberOfTabs = _maxmiumNumberOfTabs
  end


  local numbersOfTabsPerColumn = {}
  for x = 1, numberOfColumns, 1 do

    local numberOfTabs = self:getNumberOfRequiredTabsForColumn(x)
    numbersOfTabsPerColumn[x] = numberOfTabs
    remainingNumberOfTabs = remainingNumberOfTabs - numberOfTabs

  end


  if (remainingNumberOfTabs < 0) then

    -- Calculate the numbers of removable tabs per column
    local numbersOfRemovableTabsPerColumn = {}
    local maximumRemainingNumberOfTabs = remainingNumberOfTabs

    for x = 1, numberOfColumns, 1 do
      local minimumNumberOfTabs = self:getNumberOfRequiredTabsForColumn(x, true)
      local numberOfRemovableTabs = numbersOfTabsPerColumn[x] - minimumNumberOfTabs

      numbersOfRemovableTabsPerColumn[x] = numberOfRemovableTabs
      maximumRemainingNumberOfTabs = maximumRemainingNumberOfTabs + numberOfRemovableTabs
    end

    if (maximumRemainingNumberOfTabs < 0) then
      -- There are not enough removable tabs to make the table fit into the maximum number of tabs
      error("Not enough space to output ClientOutputTable")
    end

    while (remainingNumberOfTabs < 0) do

      -- Find the column with the biggest distance to the minimum number of required tabs
      local shrinkColumnNumber
      local maximumNumberOfRemovableTabs = 0
      for x = 1, numberOfColumns, 1 do

        if (numbersOfRemovableTabsPerColumn[x] > maximumNumberOfRemovableTabs) then
          maximumNumberOfRemovableTabs = numbersOfRemovableTabsPerColumn[x]
          shrinkColumnNumber = x
        end

      end

      numbersOfTabsPerColumn[shrinkColumnNumber] = numbersOfTabsPerColumn[shrinkColumnNumber] - 1
      numbersOfRemovableTabsPerColumn[shrinkColumnNumber] = numbersOfRemovableTabsPerColumn[shrinkColumnNumber] - 1
      remainingNumberOfTabs = remainingNumberOfTabs + 1

    end

  end

  return numbersOfTabsPerColumn

end


-- When ParsedTable() is called, call the __construct method
setmetatable(ParsedTable, {__call = ParsedTable.__construct})


return ParsedTable
