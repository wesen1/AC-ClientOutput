---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

---
-- Base class for client outputs.
--
-- @type BaseClientOutput
--
local BaseClientOutput = {}


---
-- The configuration of this BaseClientOutput.
--
-- @tfield ClientOutputConfiguration configuration
--
BaseClientOutput.configuration = nil


-- Metamethods

---
-- BaseClientOutput constructor.
-- This is the __call metamethod.
--
-- @tparam ClientOutputConfiguration _configuration The configuration for this ClientOutput
--
-- @treturn BaseClientOutput The BaseClientOutput instance
--
function BaseClientOutput:__construct(_configuration)
  local instance = setmetatable({}, {__index = BaseClientOutput})
  instance.configuration = _configuration

  return instance
end


-- Getters and Setters

---
-- Returns the configuration.
--
-- @treturn ClientOutputConfiguration configuration
--
function BaseClientOutput:getConfiguration()
  return self.configuration
end


-- Public Methods

---
-- Parses a target into this client output.
--
-- @tparam mixed _target The target
--
function BaseClientOutput:parse(_target)
end

---
-- Returns the number of tabs that this client output's content requires.
--
-- @treturn int The number of required tabs
--
function BaseClientOutput:getNumberOfRequiredTabs()
end

---
-- Returns the minimum number of tabs that this client output's content requires.
--
-- @treturn int The minimum number of required tabs
--
function BaseClientOutput:getMinimumNumberOfRequiredTabs()
end

---
-- Returns the output rows to display this client output's contents.
--
-- @treturn string[] The output rows
--
function BaseClientOutput:getOutputRows()
end

---
-- Returns the output rows padded with tabs until a specified tab number.
--
-- @tparam int _tabNumber The tab number
--
-- @treturn string[] The output rows padded with tabs
--
function BaseClientOutput:getOutputRowsPaddedWithTabs(_tabNumber)
end


-- When BaseClientOutput() is called, call the __construct method
setmetatable(BaseClientOutput, {__call = BaseClientOutput.__construct})


return BaseClientOutput
