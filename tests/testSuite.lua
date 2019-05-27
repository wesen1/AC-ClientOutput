---
-- @author wesen
-- @copyright 2018-2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

---
-- The lua unit test suite
-- Runs all tests from the "unit" folder
-- Also collects code coverage information by requiring luacov
--

local lfs = require("lfs")
local luaunit = require("luaunit")

require("luacov")

--
-- Add the path to the AC-ClientOutput classes to the package path list, so the require paths can match
-- the ones that are used in the "src" folder
-- This is required to mock dependencies in each TestCase
--
package.path = package.path .. ";../src/?.lua"


---
-- Requires all unit test lua files from a specified directory recursively.
--
-- @tparam string _testDirectoryPath The path to the directory relative from this file's directory
--
local function requireTests(_testDirectoryPath)

  for fileName in lfs.dir(_testDirectoryPath) do

    if (fileName ~= "." and fileName ~= "..") then

      local filePath = _testDirectoryPath .. "/" .. fileName
      local attr = lfs.attributes(filePath)

      if (attr.mode == "directory") then
        requireTests(filePath)
      elseif (fileName:match("^Test.+\.lua$")) then

        local className = fileName:gsub("\.lua$", "")
        local classRequirePath = filePath:gsub("\.lua$", "")

        -- Add the class to the "globals" table because luaunit will only execute test functions that
        -- start with "test" and that it finds inside that table
        _G[className] = require(classRequirePath)

      end

    end

  end

end


-- Script

-- Require all unit test lua files in the "unit" directory
requireTests("unit")

-- Run the tests and exit the script with luaunit's return status
os.exit(luaunit.LuaUnit.run())
