---
-- @author wesen
-- @copyright 2018-2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local luaunit = require("luaunit")
local mach = require("mach")

---
-- Base class for all unit tests.
-- Internally uses luaunit as unit test framework and mach as mocking framework.
--
local TestCase = {}


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestCase.testClassPath = nil

---
-- The test class
-- This is loaded from the corresponding lua file during each test's setup
--
-- @tfield table testClass
--
TestCase.testClass = nil

---
-- The paths of the classes that the test class depends on
-- The list must be in the format { [dependencyId] = { path = <string>, [type = "object"|"table"] }, ... }
-- Every dependency will be mocked during each test's setup
--
-- @tfield string[] dependencyPaths
--
TestCase.dependencyPaths = {}

---
-- The list of mocked dependencies
-- This list is in the format { "dependencyPackageId" => originalValue }
--
-- @tfield table mockedDependencies
--
TestCase.dependencyMocks = nil

---
-- The mocking framework
--
-- @tfield mach mach
--
TestCase.mach = mach


-- Public Methods

---
-- Method that is called before a test is executed.
--
function TestCase:setUp()

  -- Initialize the mocks
  self:initializeMocks()

  -- Unload the test class for the case that it was loaded while requiring one of its dependencies
  package.loaded[self.testClassPath] = nil

  -- Load the test class
  self.testClass = require(self.testClassPath)

end

---
-- Method that is called after a test was executed.
--
function TestCase:tearDown()

  -- Remove all packages that were not loaded before the test started
  for packagePath, _ in pairs(package.loaded) do
    if (not self.originalLoadedPackages[packagePath]) then
      package.loaded[packagePath] = nil
    end
  end

  self.originalLoadedPackages = nil
  self.dependencyMocks = nil
  self.testClass = nil

end


-- Protected Methods

---
-- Returns the mock for a object or class.
--
-- @tparam table _mockTarget The mock target (May be an object, class or table)
-- @tparam string _mockName The name of the mock
-- @tparam string _mockType The mock type (Can be either "object" or "table")
--
-- @treturn table The mock of the object or class
--
function TestCase:getMock(_mockTarget, _mockName, _mockType)

  if (_mockType == nil or _mockType == "object") then
    return mach.mock_object(_mockTarget, _mockName)
  elseif (_mockType == "table") then
    return mach.mock_table(_mockTarget, _mockName)
  end

end


-- Private Methods

---
-- Initializes the mocks for the test class dependencies.
--
function TestCase:initializeMocks()

  -- Backup the original loaded packages contents
  self.originalLoadedPackages = {}
  for packagePath, loadedPackage in pairs(package.loaded) do
    self.originalLoadedPackages[packagePath] = loadedPackage
  end

  -- Create mocks and load them into the package.loaded variable
  self.dependencyMocks = {}
  for dependencyId, dependencyInfo in pairs(self.dependencyPaths) do

    local dependencyPath = dependencyInfo["path"]

    -- Load the dependency
    local dependency = require(dependencyPath)

    -- Create a mock for the dependency
    local dependencyMock = self:getMock(dependency, dependencyId .. "Mock", dependencyInfo["type"])

    -- Replace the dependency by the mock
    package.loaded[dependencyPath] = setmetatable({}, {
      __call = function(...)
        dependencyMock.__construct(...)
        return dependencyMock
      end,
      __index = dependencyMock
    })

    -- Save the mock to be able to use it in the tests
    self.dependencyMocks[dependencyId] = dependencyMock

  end

end


-- TestCase inherits methods and attributes from luaunit
setmetatable(TestCase, {__index = luaunit})


return TestCase
