---
-- @author wesen
-- @copyright 2018-2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

---
-- Returns the output rows for a ParsedTable.
--
-- @type TableRenderer
--
local TableRenderer = {}


---
-- The numbers of tabs per column for the current ParsedTable
--
-- @tfield int|nil numbersOfTabsPerColumn
--
TableRenderer.numbersOfTabsPerColumn = nil

---
-- The rendered row fields for the current ParsedTable
--
-- @tfield string[]|nil rows
--
TableRenderer.rows = nil


-- Metamethods

---
-- TableRenderer constructor.
-- This is the __call metamethod.
--
-- @treturn TableRenderer The TableRenderer instance
--
function TableRenderer:__construct()
  local instance = setmetatable({}, {__index = TableRenderer})
  return instance
end


-- Public Methods

---
-- Returns the row output rows for a ParsedTable.
--
-- @tparam ParsedTable _parsedTable The parsed table
-- @tparam int _maximumNumberOfTabs The maximum number of tabs avaiable for each row
-- @tparam bool _padWithTabs Whether to pad the rows with tabs until the maximum number of tabs (optional)
--
-- @treturn string[] The row output strings
--
function TableRenderer:getOutputRows(_parsedTable, _maximumNumberOfTabs, _padWithTabs)

  self.rows = {}
  self.numbersOfTabsPerColumn = _parsedTable:getNumberOfTabsPerColumn(_maximumNumberOfTabs)

  self:initializeFields(_parsedTable, _padWithTabs)
  self:mergeSubRows()
  self:fillEmptyFieldsWithTabs(_parsedTable, _padWithTabs)

  return self:generateRowStrings()

end


-- Private Methods

---
-- Initializes the fields with the results of getOutputRows() of each ParsedTable field.
--
-- @tparam ParsedTable _parsedTable The parsed table
-- @tparam bool _padWithTabs Whether to pad the rows with tabs until the maximum number of tabs (optional)
--
function TableRenderer:initializeFields(_parsedTable, _padWithTabs)

  local numberOfColumns = _parsedTable:getNumberOfColumns()
  for y, tableRow in ipairs(_parsedTable:getRows()) do

    self.rows[y] = {}
    for x = 1, numberOfColumns, 1 do

      tableRow[x]:getConfiguration():changeMaximumNumberOfTabs(self.numbersOfTabsPerColumn[x])
      if (_padWithTabs or x < numberOfColumns) then
        self.rows[y][x] = tableRow[x]:getOutputRowsPaddedWithTabs()
      else
        self.rows[y][x] = tableRow[x]:getOutputRows()
      end

    end

  end

end

---
-- Combines the rows of the sub tables with the total table.
-- This is done by creating an entirely new table.
--
function TableRenderer:mergeSubRows()

  local mainTableInsertIndex = 1

  local mergedRows = {}
  for _, tableRow in ipairs(self.rows) do

    mergedRows[mainTableInsertIndex] = {}

    local maximumMainTableInsertIndexForRow = mainTableInsertIndex
    for x, tableField in ipairs(tableRow) do

      local mainTableInsertIndexForSubTable = mainTableInsertIndex
      local isFirstSubRow = true

      for _, subRow in ipairs(tableField) do

        if (isFirstSubRow) then
          isFirstSubRow = false
        else

          mainTableInsertIndexForSubTable = mainTableInsertIndexForSubTable + 1
          if (mainTableInsertIndexForSubTable > maximumMainTableInsertIndexForRow) then
            mergedRows[mainTableInsertIndexForSubTable] = {}
            maximumMainTableInsertIndexForRow = mainTableInsertIndexForSubTable
          end

        end

        mergedRows[mainTableInsertIndexForSubTable][x] = subRow

      end

    end

    mainTableInsertIndex = maximumMainTableInsertIndexForRow + 1

  end

  self.rows = mergedRows

end

---
-- Fills all empty fields with tabs.
--
-- @tparam ParsedTable _parsedTable The parsed table
-- @tparam bool _padWithTabs Whether to pad the rows with tabs until the maximum number of tabs (optional)
--
function TableRenderer:fillEmptyFieldsWithTabs(_parsedTable, _padWithTabs)

  local numberOfColumns = _parsedTable:getNumberOfColumns()
  for y, tableRow in ipairs(self.rows) do
    for x = 1, numberOfColumns, 1 do

      if (tableRow[x] == nil) then
        if (_padWithTabs or x < numberOfColumns) then
          self.rows[y][x] = string.rep("\t", self.numbersOfTabsPerColumn[x])
        else
          self.rows[y][x] = ""
        end
      end

    end
  end

end

---
-- Generates and returns the row strings from the current rows.
--
-- @treturn string[] The row strings
--
function TableRenderer:generateRowStrings()

  local rowOutputStrings = {}
  for y, row in ipairs(self.rows) do
    rowOutputStrings[y] = table.concat(row, "")
  end

  return rowOutputStrings

end


-- When TableRenderer() is called, call the __construct method
setmetatable(TableRenderer, {__call = TableRenderer.__construct})


return TableRenderer
