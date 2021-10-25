---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the Position List works as expected.
--
local TestList = TestCase:extend()

---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestList.testClassPath = "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.List"


function TestList:testCanFindPositionThatContains()

  local List = self.testClass

  local TestList = List({})

end


-- TODO: TestCases =
-- 1. no substrings = nil
-- 2. Exactly one sub string before the position = that position
-- 3. Exactly one that contains the position = nil
-- 4. Exactly one after the position = nil
-- 5. Two before the position = second position
-- 6. One before and one contains = first position
-- 7. One before and one after = first position
-- 8. One contains and one after = nil
-- 9. Two after = nil

--function TestList:testCanReturnLastSubstringPositionBefore()
--end


return TestList
