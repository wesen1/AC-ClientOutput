---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the Position works as expected.
--
local TestPosition = TestCase:extend()

---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestPosition.testClassPath = "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.Position"


---
-- Checks that a Position can return whether it starts after a specific string position.
--
function TestPosition:testCanReturnWhetherItStartsAfterPosition()

  local Position = self.testClass

  local singleCharacterPosition = Position(4, 4)
  self:assertTrue(singleCharacterPosition:startsAfterPosition(1))
  self:assertTrue(singleCharacterPosition:startsAfterPosition(2))
  self:assertTrue(singleCharacterPosition:startsAfterPosition(3))
  self:assertFalse(singleCharacterPosition:startsAfterPosition(4))
  self:assertFalse(singleCharacterPosition:startsAfterPosition(5))
  self:assertFalse(singleCharacterPosition:startsAfterPosition(6))
  self:assertFalse(singleCharacterPosition:startsAfterPosition(7))
  self:assertFalse(singleCharacterPosition:startsAfterPosition(8))

  local multipleCharacterPosition = Position(7, 12)
  self:assertTrue(multipleCharacterPosition:startsAfterPosition(1))
  self:assertTrue(multipleCharacterPosition:startsAfterPosition(2))
  self:assertTrue(multipleCharacterPosition:startsAfterPosition(3))
  self:assertTrue(multipleCharacterPosition:startsAfterPosition(4))
  self:assertTrue(multipleCharacterPosition:startsAfterPosition(5))
  self:assertTrue(multipleCharacterPosition:startsAfterPosition(6))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(7))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(8))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(9))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(10))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(11))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(12))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(13))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(14))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(15))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(16))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(17))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(18))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(19))
  self:assertFalse(multipleCharacterPosition:startsAfterPosition(20))

end

---
-- Checks that a Position can return whether it ends before a specific string position.
--
function TestPosition:testCanReturnWhetherItEndsBeforePosition()

  local Position = self.testClass

  local singleCharacterPosition = Position(4, 4)
  self:assertFalse(singleCharacterPosition:endsBeforePosition(1))
  self:assertFalse(singleCharacterPosition:endsBeforePosition(2))
  self:assertFalse(singleCharacterPosition:endsBeforePosition(3))
  self:assertFalse(singleCharacterPosition:endsBeforePosition(4))
  self:assertTrue(singleCharacterPosition:endsBeforePosition(5))
  self:assertTrue(singleCharacterPosition:endsBeforePosition(6))
  self:assertTrue(singleCharacterPosition:endsBeforePosition(7))
  self:assertTrue(singleCharacterPosition:endsBeforePosition(8))

  local multipleCharacterPosition = Position(7, 12)
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(1))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(2))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(3))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(4))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(5))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(6))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(7))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(8))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(9))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(10))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(11))
  self:assertFalse(multipleCharacterPosition:endsBeforePosition(12))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(13))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(14))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(15))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(16))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(17))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(18))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(19))
  self:assertTrue(multipleCharacterPosition:endsBeforePosition(20))

end

---
-- Checks that a Position can return whether it contains a specific string position.
--
function TestPosition:testCanReturnWhetherItContainsPosition()

  local Position = self.testClass

  local singleCharacterPosition = Position(4, 4)
  self:assertFalse(singleCharacterPosition:containsPosition(1))
  self:assertFalse(singleCharacterPosition:containsPosition(2))
  self:assertFalse(singleCharacterPosition:containsPosition(3))
  self:assertTrue(singleCharacterPosition:containsPosition(4))
  self:assertFalse(singleCharacterPosition:containsPosition(5))
  self:assertFalse(singleCharacterPosition:containsPosition(6))
  self:assertFalse(singleCharacterPosition:containsPosition(7))
  self:assertFalse(singleCharacterPosition:containsPosition(8))

  local multipleCharacterPosition = Position(7, 12)
  self:assertFalse(multipleCharacterPosition:containsPosition(1))
  self:assertFalse(multipleCharacterPosition:containsPosition(2))
  self:assertFalse(multipleCharacterPosition:containsPosition(3))
  self:assertFalse(multipleCharacterPosition:containsPosition(4))
  self:assertFalse(multipleCharacterPosition:containsPosition(5))
  self:assertFalse(multipleCharacterPosition:containsPosition(6))
  self:assertTrue(multipleCharacterPosition:containsPosition(7))
  self:assertTrue(multipleCharacterPosition:containsPosition(8))
  self:assertTrue(multipleCharacterPosition:containsPosition(9))
  self:assertTrue(multipleCharacterPosition:containsPosition(10))
  self:assertTrue(multipleCharacterPosition:containsPosition(11))
  self:assertTrue(multipleCharacterPosition:containsPosition(12))
  self:assertFalse(multipleCharacterPosition:containsPosition(13))
  self:assertFalse(multipleCharacterPosition:containsPosition(14))
  self:assertFalse(multipleCharacterPosition:containsPosition(15))
  self:assertFalse(multipleCharacterPosition:containsPosition(16))
  self:assertFalse(multipleCharacterPosition:containsPosition(17))
  self:assertFalse(multipleCharacterPosition:containsPosition(18))
  self:assertFalse(multipleCharacterPosition:containsPosition(19))
  self:assertFalse(multipleCharacterPosition:containsPosition(20))

end

---
-- Checks that a Position can return whether a specific string position matches its start or end position.
--
function TestPosition:testCanReturnWhetherPositionIsStartOrEndPosition()

  local Position = self.testClass

  local singleCharacterPosition = Position(4, 4)
  self:assertFalse(singleCharacterPosition:isStartOrEndPosition(1))
  self:assertFalse(singleCharacterPosition:isStartOrEndPosition(2))
  self:assertFalse(singleCharacterPosition:isStartOrEndPosition(3))
  self:assertTrue(singleCharacterPosition:isStartOrEndPosition(4))
  self:assertFalse(singleCharacterPosition:isStartOrEndPosition(5))
  self:assertFalse(singleCharacterPosition:isStartOrEndPosition(6))
  self:assertFalse(singleCharacterPosition:isStartOrEndPosition(7))
  self:assertFalse(singleCharacterPosition:isStartOrEndPosition(8))

  local multipleCharacterPosition = Position(7, 12)
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(1))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(2))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(3))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(4))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(5))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(6))
  self:assertTrue(multipleCharacterPosition:isStartOrEndPosition(7))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(8))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(9))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(10))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(11))
  self:assertTrue(multipleCharacterPosition:isStartOrEndPosition(12))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(13))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(14))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(15))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(16))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(17))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(18))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(19))
  self:assertFalse(multipleCharacterPosition:isStartOrEndPosition(20))

end


return TestPosition
