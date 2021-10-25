---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the TabStopCalculator class works as expected.
--
-- @type TestTabStopCalculator
--
local TestTabStopCalculator = TestCase:extend()


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestTabStopCalculator.testClassPath = "AC-ClientOutput/ClientOutput/Util/TabStopCalculator"


---
-- Checks that the TabStopCalculator can correctly calculate the number of passed tab stops.
--
function TestTabStopCalculator:testCanCalculateNumberOfPassedTabStops()

  local TabStopCalculator = self.testClass
  for _, testValueSet in ipairs(self:canCalculateNumberOfPassedTabStopsProvider()) do

    local tabStopCalculator = TabStopCalculator(testValueSet["tabWidth"])

    self:assertEquals(
      tabStopCalculator:getNumberOfPassedTabStops(testValueSet["textPixelPosition"]),
      testValueSet["expectedNumberOfPassedTabs"]
    )

  end

end

---
-- Data provider for TestTabStopCalculator:testCanCalculateNumberOfPassedTabStops().
--
function TestTabStopCalculator:canCalculateNumberOfPassedTabStopsProvider()

  return {

    -- Text position exactly on tab stop
    { ["tabWidth"] = 100, ["textPixelPosition"] = 200, ["expectedNumberOfPassedTabs"] = 2 },
    { ["tabWidth"] = 37, ["textPixelPosition"] = 111, ["expectedNumberOfPassedTabs"] = 3 },

    -- Text position close before tab stop
    { ["tabWidth"] = 62, ["textPixelPosition"] = 97, ["expectedNumberOfPassedTabs"] = 1 },
    { ["tabWidth"] = 24, ["textPixelPosition"] = 182, ["expectedNumberOfPassedTabs"] = 7 },

    -- Text position close after tab stop
    { ["tabWidth"] = 67, ["textPixelPosition"] = 70, ["expectedNumberOfPassedTabs"] = 1 },
    { ["tabWidth"] = 13, ["textPixelPosition"] = 146, ["expectedNumberOfPassedTabs"] = 11 },

    -- Text position 0
    { ["tabWidth"] = 12, ["textPixelPosition"] = 0, ["expectedNumberOfPassedTabs"] = 0 },
    { ["tabWidth"] = 51, ["textPixelPosition"] = 0, ["expectedNumberOfPassedTabs"] = 0 }
  }

end

---
-- Checks that the TabStopCalculator can get the number of tabs to a tab stop from a text pixel position.
--
function TestTabStopCalculator:testCanGetNumberOfTabsToTabStop()

  local TabStopCalculator = self.testClass
  for _, testValueSet in ipairs(self:canGetNumberOfTabsToTabStopProvider()) do

    local tabStopCalculator = TabStopCalculator(testValueSet["tabWidth"])
    local textPixelPosition = testValueSet["textPixelPosition"]
    local targetTabStopNumber = testValueSet["targetTabStopNumber"]

    self:assertEquals(
      tabStopCalculator:getNumberOfTabsToTabStop(textPixelPosition, targetTabStopNumber),
      testValueSet["expectedNumberOfTabs"]
    )
  end

end

---
-- Data provider for TestTabStopCalculator:testCanGetNumberOfTabsToTabStop().
--
function TestTabStopCalculator:canGetNumberOfTabsToTabStopProvider()

  return {

    -- Text pixel position before a tab stop
    {
      ["tabWidth"] = 20,
      ["textPixelPosition"] = 30,
      ["targetTabStopNumber"] = 2,
      ["expectedNumberOfTabs"] = 1
    },
    {
      ["tabWidth"] = 15,
      ["textPixelPosition"] = 44,
      ["targetTabStopNumber"] = 4,
      ["expectedNumberOfTabs"] = 2
    },

    -- Text pixel position on a tab stop that is not the target tab stop
    {
      ["tabWidth"] = 17,
      ["textPixelPosition"] = 34,
      ["targetTabStopNumber"] = 5,
      ["expectedNumberOfTabs"] = 3
    },
    {
      ["tabWidth"] = 12,
      ["textPixelPosition"] = 36,
      ["targetTabStopNumber"] = 7,
      ["expectedNumberOfTabs"] = 4
    },


    -- Text pixel position exactly on target tab stop
    {
      ["tabWidth"] = 22,
      ["textPixelPosition"] = 44,
      ["targetTabStopNumber"] = 2,
      ["expectedNumberOfTabs"] = 0
    },
    {
      ["tabWidth"] = 31,
      ["textPixelPosition"] = 93,
      ["targetTabStopNumber"] = 3,
      ["expectedNumberOfTabs"] = 0
    },

    -- Text pixel position beyond target tab stop
    {
      ["tabWidth"] = 10,
      ["textPixelPosition"] = 40,
      ["targetTabStopNumber"] = 3,
      ["expectedNumberOfTabs"] = -1
    },
    {
      ["tabWidth"] = 30,
      ["textPixelPosition"] = 150,
      ["targetTabStopNumber"] = 3,
      ["expectedNumberOfTabs"] = -2
    }
  }

end

---
-- Checks that the TabStopCalculator can get the next tab stop number from a text pixel position.
--
function TestTabStopCalculator:testCanGetNextTabStopNumber()

  local TabStopCalculator = self.testClass
  for _, testValueSet in ipairs(self:canGetNextTabStopNumberProvider()) do

    local tabStopCalculator = TabStopCalculator(testValueSet["tabWidth"])

    self:assertEquals(
      tabStopCalculator:getNextTabStopNumber(testValueSet["textPixelPosition"]),
      testValueSet["expectedTabStopNumber"]
    )

  end

end

---
-- Data provider for TestTabStopCalculator:testCanGetNextTabStopNumber().
--
function TestTabStopCalculator:canGetNextTabStopNumberProvider()

  return {

    -- Text position exactly on tab stop
    { ["tabWidth"] = 44, ["textPixelPosition"] = 44, ["expectedTabStopNumber"] = 2 },
    { ["tabWidth"] = 315, ["textPixelPosition"] = 945, ["expectedTabStopNumber"] = 4 },

    -- Text position close before tab stop
    { ["tabWidth"] = 21, ["textPixelPosition"] = 39, ["expectedTabStopNumber"] = 2 },
    { ["tabWidth"] = 78, ["textPixelPosition"] = 77, ["expectedTabStopNumber"] = 1 },

    -- Text position close after tab stop
    { ["tabWidth"] = 516, ["textPixelPosition"] = 2067, ["expectedTabStopNumber"] = 5 },
    { ["tabWidth"] = 123, ["textPixelPosition"] = 742, ["expectedTabStopNumber"] = 7 },

    -- Text position 0
    { ["tabWidth"] = 170, ["textPixelPosition"] = 0, ["expectedTabStopNumber"] = 1 },
    { ["tabWidth"] = 234, ["textPixelPosition"] = 0, ["expectedTabStopNumber"] = 1 }

  }

end

---
-- Checks that the TabStopCalculator can calculate the position of the next tab stop relative to a text
-- pixel position.
--
function TestTabStopCalculator:testCanGetNextTabStopPosition()

  local TabStopCalculator = self.testClass
  for _, testValueSet in ipairs(self:canGetNextTabStopPositionProvider()) do

    local tabStopCalculator = TabStopCalculator(testValueSet["tabWidth"])

    self:assertEquals(
      tabStopCalculator:getNextTabStopPosition(testValueSet["textPixelPosition"]),
      testValueSet["expectedTabStopPosition"]
    )

  end

end

---
-- Data provider for TestTabStopCalculator:testCanGetNextTabStopPosition().
--
function TestTabStopCalculator:canGetNextTabStopPositionProvider()

  return {

    -- Text position exactly on tab stop
    { ["tabWidth"] = 665, ["textPixelPosition"] = 665, ["expectedTabStopPosition"] = 1330 },
    { ["tabWidth"] = 142, ["textPixelPosition"] = 284, ["expectedTabStopPosition"] = 426 },

    -- Text position close before tab stop
    { ["tabWidth"] = 370, ["textPixelPosition"] = 368, ["expectedTabStopPosition"] = 370 },
    { ["tabWidth"] = 439, ["textPixelPosition"] = 438, ["expectedTabStopPosition"] = 439 },

    -- Text position close after tab stop
    { ["tabWidth"] = 706, ["textPixelPosition"] = 1414, ["expectedTabStopPosition"] = 2118 },
    { ["tabWidth"] = 320, ["textPixelPosition"] = 641, ["expectedTabStopPosition"] = 960 },

    -- Text position 0
    { ["tabWidth"] = 164, ["textPixelPosition"] = 0, ["expectedTabStopPosition"] = 164 },
    { ["tabWidth"] = 24, ["textPixelPosition"] = 0, ["expectedTabStopPosition"] = 24 }

  }

end

---
-- Checks that the TabStopCalculator can convert a tab number to a text pixel position.
--
function TestTabStopCalculator:testCanConvertTabNumberToPosition()

  local TabStopCalculator = self.testClass
  for _, testValueSet in ipairs(self:canConvertTabNumberToPositionProvider()) do

    local tabStopCalculator = TabStopCalculator(testValueSet["tabWidth"])

    self:assertEquals(
      tabStopCalculator:convertTabNumberToPosition(testValueSet["tabNumber"]),
      testValueSet["expectedPosition"]
    )

  end

end

---
-- Data provider for TestTabStopCalculator:testCanConvertTabNumberToPosition().
--
function TestTabStopCalculator:canConvertTabNumberToPositionProvider()

  return {

    { ["tabWidth"] = 340, ["tabNumber"] = 2, ["expectedPosition"] = 680 },
    { ["tabWidth"] = 215, ["tabNumber"] = 4, ["expectedPosition"] = 860 },
    { ["tabWidth"] = 330, ["tabNumber"] = 1, ["expectedPosition"] = 330 },

    -- Tab number 0
    { ["tabWidth"] = 410, ["tabNumber"] = 0, ["expectedPosition"] = 0 },
    { ["tabWidth"] = 536, ["tabNumber"] = 0, ["expectedPosition"] = 0 },
    { ["tabWidth"] = 247, ["tabNumber"] = 0, ["expectedPosition"] = 0 },
  }

end


return TestTabStopCalculator
