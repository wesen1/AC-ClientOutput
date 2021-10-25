---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TableParser works as expected.
--
-- @type TestTableParser
--
local TestTableParser = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestTableParser.testClassPath = "AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/TableParser"

---
-- The paths of the classes that the test class depends on
--
-- @tfield string[] dependencyPaths
--
TestTableParser.dependencyPaths = {
  { id = "ClientOutputString", path = "AC-ClientOutput/ClientOutput/ClientOutputString/ClientOutputString" },
  { id = "ClientOutputTable", path = "AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTable" },
  {
    id = "ClientOutputTableConfiguration",
    path = "AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTableConfiguration"
  },
  { id = "ParsedTable", path = "AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/ParsedTable" }
}


---
-- The SymbolWidthLoader mock
--
-- @tfield table symbolWidthLoaderMock
--
TestTableParser.symbolWidthLoaderMock = {}

---
-- The TabStopCalculator mock
--
-- @tfield table tabStopCalculatorMock
--
TestTableParser.tabStopCalculatorMock = {}

---
-- The ClientOutputTableConfiguration mock
--
-- @tfield table configurationMock
--
TestTableParser.configurationMock = nil

---
-- The current test TableParser instance
--
-- @tfield TableParser tableParser
--
TestTableParser.tableParser = nil


---
-- Creates and returns a new TableParser instance.
--
-- @treturn TableParser The TableParser instance
--
function TestTableParser:createTableParserInstance()
  local TableParser = self.testClass
  return TableParser(self.symbolWidthLoaderMock, self.tabStopCalculatorMock)
end


---
-- Method that is called before a test is executed.
-- Creates a ClientOutputTableConfiguration mock and a new TableParser instance.
--
function TestTableParser:setUp()
  TestCase.setUp(self)

  self.configurationMock = self:getMock("AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTableConfiguration")
  self.tableParser = self:createTableParserInstance()
end


---
-- Checks whether raw tables can be parsed as expected.
--
function TestTableParser:testCanParseTable()

  for _, dataSet in ipairs(self:canParseTableProvider()) do

    local rawTable = dataSet["rawTable"]
    local expectedClientOutputs = dataSet["expectedClientOutputs"]

    local parsedTableMock = self:getMock("AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/ParsedTable")
    local expectedCalls = self.dependencyMocks["ParsedTable"].__call
                                                             :should_be_called()
                                                             :and_will_return(parsedTableMock)

    self:expectClientOutputCreations(expectedCalls, expectedClientOutputs, parsedTableMock)

    expectedCalls:when(
      function()
        self.tableParser:parse(rawTable, self.configurationMock)
      end
    )

  end

end

---
-- Returns the data sets for the TableParserTest:testCanParseTable test.
--
-- @treturn table[] The data sets
--
function TestTableParser:canParseTableProvider()

  return {

    -- Data set 1: Different datatypes that are converted to strings
    {
      rawTable = {
        [1] = { "hallo", false },
        [2] = { 5.1, 4 }
      },
      expectedClientOutputs = {
        [1] = {
          { ["type"] = "string", ["value"] = "hallo" },
          { ["type"] = "string", ["value"] = "false" }
        },
        [2] = {
          { ["type"] = "string", ["value"] = "5.1" },
          { ["type"] = "string", ["value"] = "4" }
        }
      }
    },

    -- Data set 2: Sub tables
    {
      rawTable = {
        [1] = { { "a", "sub", "table" }, "symbols" },
        [2] = { 5, { { "sub", "sub", "table" }, "hello" } }
      },
      expectedClientOutputs = {
        [1] = {
          { ["type"] = "table", ["value"] = { "a", "sub", "table" } },
          { ["type"] = "string", ["value"] = "symbols" }
        },
        [2] = {
          { ["type"] = "string", ["value"] = "5" },
          { ["type"] = "table", ["value"] = { { "sub", "sub", "table" }, "hello" } }
        }
      }
    },

    -- Data set 3: Rows with a single non table value
    {
      rawTable = {
        [1] = "hello",
        [2] = "test",
        [3] = { "neu" }
      },
      expectedClientOutputs = {
        [1] = { { ["type"] = "string", ["value"] = "hello" } },
        [2] = { { ["type"] = "string", ["value"] = "test" } },
        [3] = { { ["type"] = "string", ["value"] = "neu" } }
      }
    }
  }

end


-- Private Methods

---
-- Creates the necessary mock expectations to expect the creation of a list of ClientOutputs.
--
-- @tparam ExpectedCall _expectedCalls The expected calls chain
-- @tparam table _expectedClientOutputs The expected ClientOutput configurations from a data set
-- @tparam ParsedTable _parsedTableMock The ParsedTable mock to which the ClientOutputs are expected to be added
--
function TestTableParser:expectClientOutputCreations(_expectedCalls, _expectedClientOutputs, _parsedTableMock)

  -- Calculate the table's dimensions
  local numberOfRows = #_expectedClientOutputs

  local numberOfColumns
  if (numberOfRows == 0) then
    numberOfColumns = 0
  else

    if (type(_expectedClientOutputs[1]) == "table") then
      numberOfColumns = #_expectedClientOutputs[1]
    else
      numberOfColumns = 1
    end

  end


  -- Expect ClientOutput creation related function calls
  for y = 1, numberOfRows, 1 do

    -- ParsedTable:addRow should be called one time per row
    _expectedCalls:and_then(
      _parsedTableMock.addRow
                      :should_be_called()
    )

    for x = 1, numberOfColumns, 1 do

      local expectedClientOutput = _expectedClientOutputs[y][x]

      -- One ClientOutput per field should be created
      local clientOutputMock = self:expectClientOutputCreation(
        _expectedCalls, y, x, expectedClientOutput["value"], expectedClientOutput["type"]
      )

      -- The ClientOutput should be added to the parsed table
      _expectedCalls:and_then(
        _parsedTableMock.addRowField
                        :should_be_called_with(clientOutputMock)
      )

    end
  end

end

---
-- Expects the creation of a ClientOutput.
--
-- @tparam ExpectedCall _expectedCalls The expected calls chain
-- @tparam int _y The row number
-- @tparam int _x The column number
-- @tparam mixed _value The expected value of the ClientOutput
-- @tparam string _type The type of the ClientOutput (either "string" or "table")
--
function TestTableParser:expectClientOutputCreation(_expectedCalls, _y, _x, _value, _type)

  local fieldConfigurationMock = {}

  local isClientOutputTable = (_type == "table")
  local mockDependencyId, mockClassPath
  if (_type == "string") then
    mockDependencyId = "ClientOutputString"
    mockClassPath = "AC-ClientOutput.ClientOutput.ClientOutputString.ClientOutputString"
  elseif (isClientOutputTable) then
    mockDependencyId = "ClientOutputTable"
    mockClassPath = "AC-ClientOutput.ClientOutput.ClientOutputTable.ClientOutputTable"
  end

  local clientOutputMock = self:getMock(mockClassPath)

  _expectedCalls:and_then(

    -- The field configuration should be fetched
    self.configurationMock.getConfigurationForField
                          :should_be_called_with(_y, _x, isClientOutputTable)
                          :and_will_return(fieldConfigurationMock)
  ):and_then(

    -- A ClientOutputString for the field should be created
    self.dependencyMocks[mockDependencyId].__call
                                          :should_be_called_with(
                                            self.symbolWidthLoaderMock,
                                            self.tabStopCalculatorMock,
                                            fieldConfigurationMock
                                          )
                                          :and_will_return(clientOutputMock)
  ):and_then(

    -- The expected value should be parsed into the ClientOutputString
    clientOutputMock.parse
                    :should_be_called_with(self.mach.match(_value))
  )

  return clientOutputMock

end


return TestTableParser
