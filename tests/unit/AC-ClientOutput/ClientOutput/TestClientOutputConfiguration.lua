---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require("TestFrameWork/TestCase")


local TestClientOutputConfiguration = setmetatable({}, {__index = TestCase})


TestClientOutputConfiguration.testClassPath = "AC-ClientOutput/ClientOutput/ClientOutputConfiguration"

TestClientOutputConfiguration.dependencyPaths = {
  TabStopCalculator = { ["path"] = "AC-ClientOutput/ClientOutput/Util/TabStopCalculator" }
}


--[[
function TestClientOutputConfiguration:testHallo()
end
--]]


return TestClientOutputConfiguration
