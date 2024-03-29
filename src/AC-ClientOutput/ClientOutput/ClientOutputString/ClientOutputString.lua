---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseClientOutput = require("AC-ClientOutput/ClientOutput/BaseClientOutput")
local StringSplitter = require("AC-ClientOutput/ClientOutput/ClientOutputString/StringSplitter")
local StringWidthCalculator = require("AC-ClientOutput/ClientOutput/ClientOutputString/StringWidthCalculator")

---
-- Represents a output string for the console in the players games.
-- Allows to split a string into rows based on a specified width.
--
-- @type ClientOutputString
--
local ClientOutputString = {}


---
-- The raw string
-- The text may not contain the special character "\n"
--
-- @tfield string string
--
ClientOutputString.string = nil

--
-- The client output string splitter
--
-- @tfield ClientOutputStringSplitter splitter
--
ClientOutputString.splitter = nil

---
-- The string width calculator
--
-- @tfield StringWidthCalculator stringWidthCalculator
--
ClientOutputString.stringWidthCalculator = nil

---
-- The tab stop calculator
--
-- @tfield TabStopCalculator tabStopCalculator
--
ClientOutputString.tabStopCalculator = nil


-- Metamethods

---
-- ClientOutputString constructor.
-- This is the __call metamethod.
--
-- @tparam SymbolWidthLoader _symbolWidthLoader The symbol width loader
-- @tparam TabStopCalculator _tabStopCalculator The tab stop calculator
-- @tparam ClientOutputConfiguration _configuration The configuration
--
-- @treturn ClientOutputString The ClientOutputString instance
--
function ClientOutputString:__construct(_symbolWidthLoader, _tabStopCalculator, _configuration)
  local instance = BaseClientOutput(_configuration)
  setmetatable(instance, {__index = ClientOutputString})

  instance.tabStopCalculator = _tabStopCalculator
  instance.splitter = StringSplitter(instance, _symbolWidthLoader, _tabStopCalculator)
  instance.stringWidthCalculator = StringWidthCalculator(_symbolWidthLoader, _tabStopCalculator)

  return instance
end


-- Getters and Setters

---
-- Returns the target string.
--
-- @treturn string The target string
--
function ClientOutputString:getString()
  return self.string
end


-- Public Methods

---
-- Parses a string into this ClientOutputString.
--
-- @tparam string _string The string to parse
--
function ClientOutputString:parse(_string)
  self.string = _string:gsub("\n", "")
end

---
-- Returns the number of tabs that this client output's content requires.
--
-- @treturn int The number of required tabs
--
function ClientOutputString:getNumberOfRequiredTabs()
  self.stringWidthCalculator:reset()
  return self.tabStopCalculator:getNextTabStopNumber(self.stringWidthCalculator:getStringWidth(self.string))
end

---
-- Returns the minimum number of tabs that this client output's content requires.
--
-- @treturn int The minimum number of required tabs
--
function ClientOutputString:getMinimumNumberOfRequiredTabs()
  return 1
end

---
-- Returns the output rows to display this client output's contents.
--
-- @treturn string[] The output rows
--
function ClientOutputString:getOutputRows()
  return self.splitter:getRows()
end

---
-- Returns the output rows padded with tabs until the configured maxmimum number of tabs.
--
-- @treturn string[] The output rows padded with tabs
--
function ClientOutputString:getOutputRowsPaddedWithTabs()
  return self.splitter:getRows(self.configuration:getMaximumNumberOfTabs())
end


setmetatable(
  ClientOutputString,
  {
    -- ClientOutputString inherits methods and attributes from BaseClientOutput
    __index = BaseClientOutput,

    -- When ClientOutputString() is called, call the __construct method
    __call = ClientOutputString.__construct
  }
)


return ClientOutputString
