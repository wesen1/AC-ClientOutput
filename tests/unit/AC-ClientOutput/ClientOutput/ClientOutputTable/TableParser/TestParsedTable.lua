---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require("TestFrameWork/TestCase")

local TestParsedTable = {}


TestParsedTable.testClassPath = "AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/ParsedTable"



function TestParsedTable:testCanAddRows()

  local ParsedTable = self.testClass
  local parsedTable = ParsedTable()

  -- Initially, the parsed tables contains 0 rows
  self.assertEquals(#parsedTable:getRows(), 0)

  parsedTable:addRow()
  self.assertEquals(#parsedTable:getRows(), 1)

  parsedTable:addRow()
  self.assertEquals(#parsedTable:getRows(), 2)

  -- Add 3 rows
  for i = 1, 3, 1 do
    parsedTable:addRow()
  end
  self.assertEquals(#parsedTable:getRows(), 5)

end

function TestParsedTable:testCanAddRowFields()

  local ParsedTable = self.testClass
  local parsedTable = ParsedTable()

  local clientOutputMock = {}

  -- Add the first row
  parsedTable:addRow()

  self.assertEquals(0, #parsedTable:getRows()[1])

  parsedTable:addRowField(clientOutputMock)
  self.assertEquals(1, #parsedTable:getRows()[1])

  parsedTable:addRowField(clientOutputMock)
  self.assertEquals(2, #parsedTable:getRows()[1])

  for i = 1, 5, 1 do
    parsedTable:addRowField(clientOutputMock)
  end
  self.assertEquals(7, #parsedTable:getRows()[1])

  -- Add a second row
  parsedTable:addRow()

  self.assertEquals(7, #parsedTable:getRows()[1])
  self.assertEquals(0, #parsedTable:getRows()[2])

  parsedTable:addRowField(clientOutputMock)

  self.assertEquals(7, #parsedTable:getRows()[1])
  self.assertEquals(1, #parsedTable:getRows()[2])

  parsedTable:addRowField(clientOutputMock)

  self.assertEquals(7, #parsedTable:getRows()[1])
  self.assertEquals(2, #parsedTable:getRows()[2])

end


function TestParsedTable:testCanReturnNumberOfColumns()

  local ParsedTable = self.testClass
  local parsedTable = ParsedTable()

  self.assertEquals(0, parsedTable:getNumberOfColumns())

  -- Add the first row
  parsedTable:addRow()

  for i = 1, 15, 1 do
    parsedTable:addRowField({})
    self.assertEquals(i, parsedTable:getNumberOfColumns())
  end

end


function TestParsedTable:fillParsedTableWithFields(_parsedTable, _numberOfRows, _numberOfColumns)

  local ClientOutputString = require("AC-ClientOutput/ClientOutput/ClientOutputString/ClientOutputString")

  local testFields = {}
  for y = 1, _numberOfRows, 1 do

    testFields[y] = {}
    _parsedTable:addRow()

    for x = 1, _numberOfColumns, 1 do

      local mockName = "ClientOutputStringMock#" .. y .. "." .. x
      local testField = self:getMock(ClientOutputString, mockName, "object")
      testFields[y][x] = testField

      _parsedTable:addRowField(testField)

    end

  end

  return testFields

end

function TestParsedTable:testCanGetNumberOfRequiredTabsForColumn()

  local ParsedTable = self.testClass


  for _, dataSet in ipairs(self:getNumberOfRequiredTabsForColumnProvider()) do

    local parsedTable = ParsedTable()

    -- Prepare the test table
    local testFields = self:fillParsedTableWithFields(
      parsedTable, dataSet["numberOfRows"], dataSet["numberOfColumns"]
    )

    local expectedCalls
    for i, expectedCallInfos in ipairs(dataSet["expectedFieldCalls"]) do

      local y = expectedCallInfos["y"]
      local x = expectedCallInfos["x"]
      local methodName = expectedCallInfos["methodName"]

      local expectedCall = testFields[y][x][methodName]:should_be_called()
                                                       :and_will_return(expectedCallInfos["returnValue"])

      if (i == 1) then
        expectedCalls = expectedCall
      else
        expectedCalls:and_also(expectedCall)
      end

    end


    local runTestCode = function()
      local numberOfTabs = parsedTable:getNumberOfRequiredTabsForColumn(
        dataSet["targetColumnNumber"], dataSet["getMinimumNumber"]
      )
      self.assertEquals(numberOfTabs, dataSet["expectedNumberOfTabs"])
    end


    if (expectedCalls) then
      expectedCalls:when(runTestCode)
    else
      runTestCode()
    end

  end

end

function TestParsedTable:getNumberOfRequiredTabsForColumnProvider()

  return {

    -- Test Case A: getMinimumNumber = false
    {
      numberOfRows = 5,
      numberOfColumns = 4,

      targetColumnNumber = 3,
      getMinimumNumber = false,

      expectedFieldCalls = {
        { y = 1, x = 3, methodName = "getNumberOfRequiredTabs", returnValue = 5 },
        { y = 2, x = 3, methodName = "getNumberOfRequiredTabs", returnValue = 1 },
        { y = 3, x = 3, methodName = "getNumberOfRequiredTabs", returnValue = 4 },
        { y = 4, x = 3, methodName = "getNumberOfRequiredTabs", returnValue = 2 },
        { y = 5, x = 3, methodName = "getNumberOfRequiredTabs", returnValue = 5 }
      },

      expectedNumberOfTabs = 5

    },

    -- Test Case B: getMinimumNumber = true
    {
      numberOfRows = 3,
      numberOfColumns = 3,

      targetColumnNumber = 1,
      getMinimumNumber = true,

      expectedFieldCalls = {
        { y = 1, x = 1, methodName = "getMinimumNumberOfRequiredTabs", returnValue = 2 },
        { y = 2, x = 1, methodName = "getMinimumNumberOfRequiredTabs", returnValue = 3 },
        { y = 3, x = 1, methodName = "getMinimumNumberOfRequiredTabs", returnValue = 3 },
      },

      expectedNumberOfTabs = 3
    },

    -- Test Case C: Target column number is bigger than number of columns
    {
      numberOfRows = 5,
      numberOfColumns = 2,

      targetColumnNumber = 4,
      getMinimumNumber = true,

      expectedFieldCalls = {
      },

      expectedNumberOfTabs = 0
    }
  }

end


setmetatable(TestParsedTable, {__index = TestCase})


return TestParsedTable
