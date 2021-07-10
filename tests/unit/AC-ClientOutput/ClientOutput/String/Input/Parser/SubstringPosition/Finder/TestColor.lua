---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the Color finder works as expected.
--
local TestColor = TestCase:extend()

---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestColor.testClassPath = "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Finder.Color"


---
-- Checks that color positions inside lines are found as expected.
--
function TestColor:testCanFindColorPositions()

  local Position = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Position"

  local dataSets = {
    ["no colors"] = {
      line = "hello world",
      expectedPositions = {}
    },

    ["exactly one color"] = {
      line = "hello \fJworld",
      expectedPositions = {
        Position(7, 8)
      }
    },

    ["multiple colors"] = {
      line = "hi \f3gema \f9pros",
      expectedPositions = {
        Position(4, 5),
        Position(11, 12)
      }
    },

    ["multiple colors in sequence"] = {
      line = "Coming in with\fA\fDthe flag!",
      expectedPositions = {
        Position(15, 16),
        Position(17, 18)
      }
    },

    ["color at start"] = {
      line = "\f3[ERROR] Auto blacklisting all connected players",
      expectedPositions = {
        Position(1, 2)
      }
    },

    ["color at end"] = {
      line = "[INFO] Try gema_la_momie\fM",
      expectedPositions = {
        Position(25, 26)
      }
    }
  }

  for dataSetName, dataSet in pairs(dataSets) do
    local line = dataSet["line"]
    local expectedPositions = dataSet["expectedPositions"]

    self:canFindColorPositions(dataSetName, line, expectedPositions)
  end

end

---
-- Checks that color positions inside lines are found as expected.
--
-- @tparam string _dataSetName The data set name
-- @tparam string _line The line to search for colors
-- @tparam Position[] _expectedPositions The expected result
--
function TestColor:canFindColorPositions(_dataSetName, _line, _expectedPositions)

  local color = self:createColorInstance()
  self:assertEquals(_expectedPositions, color:findPositionsInLine(_line), _dataSetName)

end


-- Private Methods

---
-- Creates and returns a Color finder instance.
--
-- @treturn Color The created Color finder instance
--
function TestColor:createColorInstance()

  local Color = self.testClass
  local color = Color()

  self:assertEquals(Color.IDENTIFIER, color:getIdentifier())

  return color

end


return TestColor
