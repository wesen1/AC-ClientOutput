---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local ClientOutputConfiguration = require("AC-ClientOutput/ClientOutput/ClientOutputConfiguration")

---
-- Stores the configuration for a ClientOutputTable and provides methods to fetch the field configurations.
--
-- @type ClientOutputTableConfiguration
--
local ClientOutputTableConfiguration = {}


---
-- The output configuration for specific groups of the table (rows, columns and fields)
--
-- @tfield mixed[][] groupConfigurations
--
ClientOutputTableConfiguration.groupConfigurations = nil

---
-- The list of allowed configuration value names per configuration group
--
-- @tfield string[] allowedGroupValueNames
--
ClientOutputTableConfiguration.allowedGroupValueNames = nil


-- Metamethods

---
-- ClientOutputTableConfiguration constructor.
-- This is the __call metamethod.
--
-- @tparam TabStopCalculator _tabStopCalculator The tab stop calculator
--
-- @treturn ClientOutputTableConfiguration The ClientOutputTableConfiguration instance
--
function ClientOutputTableConfiguration:__construct(_tabStopCalculator)
  local instance = ClientOutputConfiguration(_tabStopCalculator)
  setmetatable(instance, {__index = ClientOutputTableConfiguration})

  instance.allowedGroupValueNames = { "newLineIndent", "lineSplitCharacters" }
  instance.groupConfigurations = {}

  return instance
end


-- Public Methods

---
-- Parses a user defined configuration.
--
-- @tparam table _configuration The configuration
-- @tparam bool _isDefaultConfiguration True if the configuration is a default configuration
--
function ClientOutputTableConfiguration:parse(_configuration, _isDefaultConfiguration)

  ClientOutputConfiguration.parse(self, _configuration, _isDefaultConfiguration)

  -- Parse row configurations
  if (type(_configuration["rows"]) == "table") then

    self.groupConfigurations["rows"] = {}
    for y, rowConfiguration in pairs(_configuration["rows"]) do
      self.groupConfigurations["rows"][y] = self:getNormalizedGroupConfiguration(rowConfiguration)
    end

  end

  -- Parse the column configurations
  if (type(_configuration["columns"]) == "table") then

    self.groupConfigurations["columns"] = {}
    for x, columnConfiguration in pairs(_configuration["columns"]) do
      self.groupConfigurations["columns"][x] = self:getNormalizedGroupConfiguration(columnConfiguration)
    end

  end

  -- Parse field configurations
  if (type(_configuration["fields"]) == "table") then

    self.groupConfigurations["fields"] = {}

    for y, rowFieldConfigurations in pairs(_configuration["fields"]) do
      if (type(rowFieldConfigurations) == "table") then

        self.groupConfigurations["fields"][y] = {}
        for x, rowFieldConfiguration in pairs(rowFieldConfigurations) do
          self.groupConfigurations["fields"][y][x] = self:getNormalizedGroupConfiguration(rowFieldConfiguration)
        end

      end
    end

  end

end


---
-- Returns the ClientOutputConfiguration for a specific table field.
--
-- @tparam int _y The y coordinate of the field
-- @tparam int _x The x coordinate of the field
-- @tparam bool _isClientOutputTable True to create a ClientOutputTableConfiguration object
--
-- @treturn ClientOutputConfiguration The ClientOutputConfiguration for the field
--
function ClientOutputTableConfiguration:getConfigurationForField(_y, _x, _isClientOutputTable)

  -- Create the ClientOutputConfiguration object
  local configuration
  if (_isClientOutputTable) then
    configuration = ClientOutputTableConfiguration(self.tabStopCalculator)
  else
    configuration = ClientOutputConfiguration(self.tabStopCalculator)
  end

  -- Copy this ClientOutputTableConfiguration's configuration into the object
  configuration:copyClientOutputConfiguration(self)

  -- Parse the group configurations
  if (self.groupConfigurations["rows"] and self.groupConfigurations["rows"][_y]) then
    configuration:parse(self.groupConfigurations["rows"][_y])
  end

  if (self.groupConfigurations["columns"] and self.groupConfigurations["columns"][_x]) then
    configuration:parse(self.groupConfigurations["columns"][_x])
  end

  if (self.groupConfigurations["fields"] and
      self.groupConfigurations["fields"][_y] and self.groupConfigurations["fields"][_y][_x]
  ) then
    configuration:parse(self.groupConfigurations["fields"][_y][_x])
  end

  return configuration

end


-- Private Methods

---
-- Extracts the allowed configuration values from a user defined group configuration.
--
-- @tparam mixed[] _groupConfiguration The user defined group configuration
--
-- @treturn mixed[] The normalized group configuration
--
function ClientOutputTableConfiguration:getNormalizedGroupConfiguration(_groupConfiguration)

  local groupConfiguration = {}
  for _, valueName in ipairs(self.allowedGroupValueNames) do
    if (_groupConfiguration[valueName] ~= nil) then
      groupConfiguration[valueName] = _groupConfiguration[valueName]
    end
  end

  return groupConfiguration

end


setmetatable(
  ClientOutputTableConfiguration,
  {
    -- ClientOutputTableConfiguration inherits methods and attributes from ClientOutputConfiguration
    __index = ClientOutputConfiguration,

    -- When ClientOutputTableConfiguration() is called, call the __construct method
    __call = ClientOutputTableConfiguration.__construct
  }
)


return ClientOutputTableConfiguration
