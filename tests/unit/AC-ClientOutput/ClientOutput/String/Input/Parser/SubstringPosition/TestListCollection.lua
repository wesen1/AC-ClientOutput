---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require "wLuaUnit.TestCase"

---
-- Checks that the ListCollection works as expected.
--
local TestListCollection = TestCase:extend()

---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestListCollection.testClassPath = "AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.ListCollection"


---
-- Checks that List's can be returned by their identifier as expected.
--
function TestListCollection:testCanReturnListByIdentifier()

  local ListCollection = self.testClass

  local listMocks = self:createListMocks(3)
  local nullListMock = self:createListMocks(1)[1]

  local listCollection = ListCollection(nullListMock)

  self:assertIs(nullListMock, listCollection:getSubstringPositionList("listA"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("listB"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("listC"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("unknownList"))

  listCollection:addSubstringPositionList("listB", listMocks[2])
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("listA"))
  self:assertIs(listMocks[2], listCollection:getSubstringPositionList("listB"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("listC"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("unknownList"))

  listCollection:addSubstringPositionList("listA", listMocks[1])
  self:assertIs(listMocks[1], listCollection:getSubstringPositionList("listA"))
  self:assertIs(listMocks[2], listCollection:getSubstringPositionList("listB"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("listC"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("unknownList"))

  listCollection:addSubstringPositionList("listC", listMocks[3])
  self:assertIs(listMocks[1], listCollection:getSubstringPositionList("listA"))
  self:assertIs(listMocks[2], listCollection:getSubstringPositionList("listB"))
  self:assertIs(listMocks[3], listCollection:getSubstringPositionList("listC"))
  self:assertIs(nullListMock, listCollection:getSubstringPositionList("unknownList"))

end


-- Private Methods

---
-- Creates and returns a given number of List mocks.
--
-- @tparam int _numberOfMocks The number of mocks to create
--
-- @treturn table[] The created List mocks
--
function TestListCollection:createListMocks(_numberOfMocks)

  local listMocks = {}
  for i = 1, _numberOfMocks, 1 do
    table.insert(
      listMocks, self:getMock("AC-ClientOutput.ClientOutput.String.Input.Parser.SubstringPosition.List")
    )
  end

  return listMocks

end


return TestListCollection
