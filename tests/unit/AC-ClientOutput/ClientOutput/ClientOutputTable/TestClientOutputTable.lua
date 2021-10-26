---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require("TestFrameWork/TestCase")

local TestClientOutputTable = setmetatable({}, {__index = TestCase})

--[[
TestClientOutputTable.testClassPath = "AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTable"

TestClientOutputTable.dependencyPaths = {
  TableRenderer = {
    ["path"] = "AC-ClientOutput/ClientOutput/ClientOutputTable/TableRenderer"
  },
  TableParser = {
    ["path"] = "AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/TableParser"
  },
  ParsedTable = {
    ["path"] = "AC-ClientOutput/ClientOutput/ClientOutputTable/TableParser/ParsedTable"
  }
}
--]]


--[[
function TestClientOutputTable:testHallo()
end
--]]


return TestClientOutputTable
