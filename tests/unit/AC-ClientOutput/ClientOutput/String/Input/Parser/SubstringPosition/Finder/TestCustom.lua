---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the Custom finder works as expected.
--
local TestCustom = TestCase:extend()

---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestCustom.testClassPath = "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Finder.Custom"


---
-- Checks that character positions inside lines are found as expected.
--
function TestCustom:testCanFindCharacterPositions()

  local Position = require "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Position"

  local dataSets = {
    ["no search characters"] = {
      searchCharacters = "abc",
      identifier = "example",
      line = "defghijk",
      expectedPositions = {}
    },

    ["one of one search characters"] = {
      searchCharacters = "a",
      identifier = "searcher",
      line = "gema",
      expectedPositions = {
        Position(4, 4)
      }
    },

    ["one of many search characters"] = {
      searchCharacters = "abcdef",
      identifier = "abcfinder",
      line = "grank",
      expectedPositions = {
        Position(3, 3)
      }
    },

    ["many single of many search characters"] = {
      searchCharacters = "eao",
      identifier = "foundyou",
      line = "gema_la_momie",
      expectedPositions = {
        Position(2, 2),
        Position(4, 4),
        Position(7, 7),
        Position(10, 10),
        Position(13, 13)
      }
    },

    ["multiple in a row of many search characters"] = {
      searchCharacters = "gema",
      identifier = "map-search",
      line = "for-pros-gema",
      expectedPositions = {
        Position(10, 13)
      }
    },

    ["multiple multiple in a row of many search characters"] = {
      searchCharacters = "hack",
      identifier = "hacker",
      line = "... hack turned on, hacking now",
      expectedPositions = {
        Position(5, 8),
        Position(21, 24)
      }
    },

    ["mixed single and multiple in a row of many search characters"] = {
      searchCharacters = "gema",
      identifier = "map-hack",
      line = "gibbed-gema11",
      expectedPositions = {
        Position(1, 1),
        Position(5, 5),
        Position(8, 11)
      }
    },

    ["after color any of many search characters"] = {
      searchCharacters = "JUMP",
      identifier = "hello",
      line = "\f3To \fJJUMP \f3press \f2spacebar!",
      expectedPositions = {
        Position(8, 11)
      }
    },

    ["color with search character"] = {
      searchCharacters = "ABC",
      identifier = "testing",
      line = "\fANo \fBYes \fCMaybe: A",
      expectedPositions = {
        Position(21, 21)
      }
    }
  }

  for dataSetName, dataSet in pairs(dataSets) do
    local searchCharacters = dataSet["searchCharacters"]
    local identifier = dataSet["identifier"]
    local line = dataSet["line"]
    local expectedPositions = dataSet["expectedPositions"]

    self:canFindCharacterPositions(dataSetName, identifier, searchCharacters, line, expectedPositions)
  end

end

---
-- Checks that character positions inside lines are found as expected.
--
-- @tparam string _dataSetName The data set name
-- @tparam string _identifier The identifier of the Custom finder
-- @tparam string _searchCharacters The search characters of the Custom finder
-- @tparam string _line The line to search for search characters
-- @tparam Position[] _expectedPositions The expected result
--
function TestCustom:canFindCharacterPositions(_dataSetName, _identifier, _searchCharacters, _line, _expectedPositions)

  local custom = self:createCustomInstance(_identifier, _searchCharacters)
  self:assertEquals(_expectedPositions, custom:findPositionsInLine(_line), _dataSetName)

end


-- Private Methods

---
-- Creates and returns a Custom finder instance.
--
-- @tparam string _identifier The identifier of the Custom finder
-- @tparam string _searchCharacters The search characters of the Custom finder
--
-- @treturn Custom The created Custom finder instance
--
function TestCustom:createCustomInstance(_identifier, _searchCharacters)

  local Custom = self.testClass
  local custom = Custom(_identifier, _searchCharacters)

  self:assertEquals(_identifier, custom:getIdentifier())

  return custom

end


return TestCustom
