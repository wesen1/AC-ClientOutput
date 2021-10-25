---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Stores the configuration for a BaseClientOutput and provides methods to parse user defined configurations.
--
-- @type ClientOutputConfiguration
--
local ClientOutputConfiguration = Object:extend()


---
-- The maximum value that may be configured for the maximumLineWidth attribute by the parse method
-- The maximumLineWidth can be set to any value if no maximum configurable line width is defined
-- This value can only be changed with the ClientOutputFactory's parse method
--
-- @tfield int|nil maximumConfigurableLineWidth
--
ClientOutputConfiguration.maximumConfigurableLineWidth = nil

---
-- The maximum line width in 3x pixels
-- If a string is wider than this width it must be split into multiple output lines
--
-- @tfield int maximumLineWidth
--
ClientOutputConfiguration.maximumLineWidth = nil

---
-- The maximum number of tabs for the BaseClientOutput
--
-- @tfield int maximumNumberOfTabs
--
ClientOutputConfiguration.maximumNumberOfTabs = nil

---
-- The indent string for auto line break lines
--
-- @tfield string newLineIndent
--
ClientOutputConfiguration.newLineIndent = nil

---
-- The characters at which the output may be split
-- The output characters will be compared to this string with the "string.match" method,
-- so this may be a lua expression
--
-- @tfield string lineSplitCharacters
--
ClientOutputConfiguration.lineSplitCharacters = nil


-- Metamethods

---
-- ClientOutputConfiguration constructor.
--
--
-- @treturn ClientOutputConfiguration The ClientOutputConfiguration instance
--
function ClientOutputConfiguration:new()
end


-- Getters and Setters

---
-- Returns the maximum line width.
--
-- @treturn int The maximum line width
--
function ClientOutputConfiguration:getMaximumLineWidth()
  return self.maximumLineWidth
end

---
-- Returns the maximum number of tabs.
--
-- @treturn int The maximum number of tabs
--
function ClientOutputConfiguration:getMaximumNumberOfTabs()
  return self.maximumNumberOfTabs
end

---
-- Returns the indent string for auto line break lines.
--
-- @treturn string The indent string
--
function ClientOutputConfiguration:getNewLineIndent()
  return self.newLineIndent
end

---
-- Returns the characters at which the output may be split.
--
-- @treturn string The characters
--
function ClientOutputConfiguration:getLineSplitCharacters()
  return self.lineSplitCharacters
end


-- Public Methods

---
-- Copies another ClientOutputConfiguration's contents into this ClientOutputConfiguration.
--
-- @tparam ClientOutputConfiguration _configuration The other ClientOutputConfiguration object
--
function ClientOutputConfiguration:copyClientOutputConfiguration(_configuration)

  self.maximumConfigurableLineWidth = _configuration.maximumConfigurableLineWidth
  self.maximumLineWidth = _configuration:getMaximumLineWidth()
  self.maximumNumberOfTabs = _configuration:getMaximumNumberOfTabs()
  self.newLineIndent = _configuration:getNewLineIndent()
  self.lineSplitCharacters = _configuration:getLineSplitCharacters()

end

---
-- Parses a user defined configuration.
--
-- @tparam table _configuration The configuration
-- @tparam bool _isDefaultConfiguration True if the configuration is a default configuration
--
function ClientOutputConfiguration:parse(_configuration, _isDefaultConfiguration)

  if (_configuration["maximumLineWidth"] ~= nil) then

    local maximumLineWidth = tonumber(_configuration["maximumLineWidth"])
    if (_isDefaultConfiguration) then
      self.maximumConfigurableLineWidth = maximumLineWidth
      self:changeMaximumLineWidth(maximumLineWidth)
    else

      if (self.maximumConfigurableLineWidth == nil or maximumLineWidth < self.maximumConfigurableLineWidth) then
        self:changeMaximumLineWidth(maximumLineWidth)
      end
    end

  end


  if (_configuration["newLineIndent"] ~= nil) then
    self.newLineIndent = _configuration["newLineIndent"]
  end

  if (_configuration["lineSplitCharacters"] ~= nil) then
    self.lineSplitCharacters = _configuration["lineSplitCharacters"]
  end

  if (_configuration["numberOfTabs"] ~= nil) then
    self:changeMaximumNumberOfTabs(tonumber(_configuration["numberOfTabs"]))
  end

end


---
-- Changes the maximum line width to a new value.
-- Also calculates the maximum number of tabs from the passed maximum line width.
--
-- @tparam int _maximumLineWidth The maximum line width
--
function ClientOutputConfiguration:changeMaximumLineWidth(_maximumLineWidth)
  self.maximumLineWidth = _maximumLineWidth
  self.maximumNumberOfTabs = self.tabStopCalculator:getNumberOfPassedTabStops(_maximumLineWidth)
end

---
-- Changes the maximum number of tabs to a new value.
-- Also calculates the maximum line width from the passed maximum number of tabs.
--
-- @tparam int _maximumNumberOfTabs The maximum number of tabs
--
function ClientOutputConfiguration:changeMaximumNumberOfTabs(_maximumNumberOfTabs)
  self.maximumNumberOfTabs = _maximumNumberOfTabs
  self.maximumLineWidth = self.tabStopCalculator:convertTabNumberToPosition(_maximumNumberOfTabs)
end


-- When ClientOutputConfiguration() is called, call the ClientOutputConfiguration.__construct() method
setmetatable(ClientOutputConfiguration, {__call = ClientOutputConfiguration.__construct})


return ClientOutputConfiguration
