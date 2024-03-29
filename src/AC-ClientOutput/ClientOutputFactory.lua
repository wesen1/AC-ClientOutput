---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local ClientOutputConfiguration = require("AC-ClientOutput/ClientOutput/ClientOutputConfiguration")
local ClientOutputTableConfiguration = require("AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTableConfiguration")
local ClientOutputString = require("AC-ClientOutput/ClientOutput/ClientOutputString/ClientOutputString")
local ClientOutputTable = require("AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTable")
local SymbolWidthLoader = require("AC-ClientOutput/ClientOutput/Util/SymbolWidthLoader")
local TabStopCalculator = require("AC-ClientOutput/ClientOutput/Util/TabStopCalculator")

---
-- Provides static methods to configure a font config and to create ClientOutputString and ClientOutputTable instances.
--
-- @type ClientOutputFactory
--
local ClientOutputFactory = {}


---
-- The ClientOutputFactory instance that will be returned by the getInstance method
--
-- @tfield ClientOutputFactory instance
--
ClientOutputFactory.instance = nil

---
-- The symbol width loader for the ClientOutputString and ClientOutputTable instances
--
-- @tfield SymbolWidthLoader symbolWidthLoader
--
ClientOutputFactory.symbolWidthLoader = nil

---
-- The tab stop calculator for the ClientOutputString and ClientOutputTable instances
--
-- @tfield TabStopCalculator tabStopCalculator
--
ClientOutputFactory.tabStopCalculator = nil

---
-- The default configuration for ClientOutputString's and ClientOutputTable's
-- These values can be overwritten by the config section in each template
--
-- @tfield ClientOutputConfiguration defaultConfiguration
--
ClientOutputFactory.defaultConfiguration = nil


-- Metamethods

---
-- ClientOutputFactory constructor.
-- This is the __call metamethod.
--
-- @treturn ClientOutputFactory The ClientOutputFactory instance
--
function ClientOutputFactory:__construct()

  local instance = setmetatable({}, {__index = ClientOutputFactory})

  -- Select the default font config
  instance:changeFontConfig("FontDefault")

  -- Set up the default configuration
  instance.defaultConfiguration = ClientOutputConfiguration(instance.tabStopCalculator)
  instance.defaultConfiguration:parse({
    maximumLineWidth = 3900,
    newLineIndent = "",
    lineSplitCharacters = " "
  }, true)

  return instance

end


-- Public Methods

---
-- Returns a ClientOutputFactory instance.
-- This will return the same instance on subsequent calls.
--
-- @treturn ClientOutputFactory The ClientOutputFactory instance
--
function ClientOutputFactory.getInstance()
  if (ClientOutputFactory.instance == nil) then
    ClientOutputFactory.instance = ClientOutputFactory()
  end

  return ClientOutputFactory.instance
end

---
-- Configures this ClientOutputFactory.
--
-- @tparam table _configuration The configuration
--
function ClientOutputFactory:configure(_configuration)

  if (type(_configuration) == "table") then
    if (_configuration["fontConfigFileName"] ~= nil) then
      self:changeFontConfig(_configuration["fontConfigFileName"])
    end

    self.defaultConfiguration:parse(_configuration, true)
  end

end


---
-- Creates and returns a ClientOutputString from a string.
--
-- @tparam string _string The string
-- @tparam table _configuration The configuration for the ClientOutputString (optional)
--
-- @treturn ClientOutputString The ClientOutputString for the string
--
function ClientOutputFactory:getClientOutputString(_string, _configuration)

  local configuration = self:generateClientOutputConfiguration(ClientOutputConfiguration, _configuration)
  local clientOutputString = ClientOutputString(self.symbolWidthLoader, self.tabStopCalculator, configuration)
  clientOutputString:parse(_string)

  return clientOutputString

end

---
-- Creates and returns a ClientOutputTable from a table.
--
-- @tparam table _table The table
-- @tparam table _configuration The configuration for the ClientOutputTable (optional)
--
-- @treturn ClientOutputTable The ClientOutputTable for the table
--
function ClientOutputFactory:getClientOutputTable(_table, _configuration)

  local configuration = self:generateClientOutputConfiguration(ClientOutputTableConfiguration, _configuration)
  local clientOutputTable = ClientOutputTable(self.symbolWidthLoader, self.tabStopCalculator, configuration)
  clientOutputTable:parse(_table)

  return clientOutputTable

end


-- Private Methods

---
-- Reinitializes the symbol width loader and the tab stop calculator to use a new font config.
--
-- @tparam string _fontConfigFileName The font config file name
--
function ClientOutputFactory:changeFontConfig(_fontConfigFileName)
  self.symbolWidthLoader = SymbolWidthLoader(_fontConfigFileName)
  self.tabStopCalculator = TabStopCalculator(self.symbolWidthLoader:getCharacterWidth("\t"))
end

---
-- Generates and returns a ClientOutputConfiguration instance.
--
-- @tparam ClientOutputConfiguration _configurationClass The configuration class type to return an instance of
-- @tparam ClientOutputConfiguration|table _configuration The custom configuration to add
--
-- @treturn ClientOutputConfiguration The generated ClientOutputConfiguration instance
--
function ClientOutputFactory:generateClientOutputConfiguration(_configurationClass, _configuration)

  if (type(_configuration) == "table" and type(_configuration.is) == "function" and _configuration.is(_configurationClass)) then
    -- The given configuration already is a ClientOutputConfiguration instance
    return _configuration
  end

  -- Create the ClientOutputConfiguration instance for the ClientOutputString
  local configuration = _configurationClass(self.tabStopCalculator)
  configuration:copyClientOutputConfiguration(self.defaultConfiguration)
  if (type(_configuration) == "table") then
    configuration:parse(_configuration)
  end

  return configuration

end


-- When ClientOutputFactory() is called, call the __construct method
setmetatable(ClientOutputFactory, {__call = ClientOutputFactory.__construct})


return ClientOutputFactory
