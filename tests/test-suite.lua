---
-- @author wesen
-- @copyright 2018-2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

--
-- Add the path to the AC-ClientOutput classes to the package path list, so the require paths can match
-- the ones that are used in the "src" folder
-- This is required to mock dependencies in each TestCase
--
package.path = package.path .. ";../src/?.lua"

local TestRunner = require "wLuaUnit.TestRunner"

---
-- The lua unit test suite
-- Runs all tests from the "unit" folder
--
local runner = TestRunner()
runner:addTestDirectory("unit")
      :enableCoverageAnalysis()
      :run()
