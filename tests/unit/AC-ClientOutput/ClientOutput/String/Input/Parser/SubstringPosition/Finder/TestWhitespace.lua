---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the Whitespace finder works as expected.
--
local TestWhitespace = TestCase:extend()

---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestWhitespace.testClassPath = "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Finder.Whitespace"


---
-- Checks that whitespace positions inside lines are found as expected.
--
function TestWhitespace:testCanFindWhitespacePositions()

  local Position = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Position"

  local dataSets = {
    ["no whitespace"] = {
      line = "no-whitespace-detected",
      expectedPositions = {}
    },

    ["exactly one whitespace"] = {
      line = "hello world",
      expectedPositions = {
        Position(6, 6)
      }
    },

    ["multiple whitespaces"] = {
      line = "high quality map",
      expectedPositions = {
        Position(5, 5),
        Position(13, 13)
      }
    },

    ["multiple whitespaces in a row"] = {
      line = "Big   gap",
      expectedPositions = {
        Position(4, 6)
      }
    },

    ["whitespace at start"] = {
      line = " hi",
      expectedPositions = {
        Position(1, 1)
      }
    },

    ["whitespace at end"] = {
      line = "bb ",
      expectedPositions = {
        Position(3, 3)
      }
    }
  }

  for dataSetName, dataSet in pairs(dataSets) do
    local line = dataSet["line"]
    local expectedPositions = dataSet["expectedPositions"]

    self:canFindWhitespacePositions(dataSetName, line, expectedPositions)
  end

end

---
-- Checks that whitespace positions inside lines are found as expected.
--
-- @tparam string _dataSetName The data set name
-- @tparam string _line The line to search for whitespace
-- @tparam Position[] _expectedPositions The expected result
--
function TestWhitespace:canFindWhitespacePositions(_dataSetName, _line, _expectedPositions)

  local whitespace = self:createWhitespaceInstance()
  self:assertEquals(_expectedPositions, whitespace:findPositionsInLine(_line), _dataSetName)

end


-- Private Methods

---
-- Creates and returns a Whitespace finder instance.
--
-- @treturn Whitespace The created Whitespace finder instance
--
function TestWhitespace:createWhitespaceInstance()

  local Whitespace = self.testClass
  local whitespace = Whitespace()

  self:assertEquals(Whitespace.IDENTIFIER, whitespace:getIdentifier())

  return whitespace

end


return TestWhitespace
