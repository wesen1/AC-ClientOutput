---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require("TestFrameWork/TestCase")

local TestClientOutputFactory = setmetatable({}, {__index = TestCase})


TestClientOutputFactory.testClassPath = "AC-ClientOutput/ClientOutputFactory"

TestClientOutputFactory.dependencyPaths = {

  ClientOutputString = {
    ["path"] = "AC-ClientOutput/ClientOutput/ClientOutputString/ClientOutputString"
  },
  ClientOutputConfiguration = {
    ["path"] = "AC-ClientOutput/ClientOutput/ClientOutputConfiguration"
  },

  ClientOutputTable = {
    ["path"] = "AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTable"
  },

  ClientOutputTableConfiguration = {
    ["path"] ="AC-ClientOutput/ClientOutput/ClientOutputTable/ClientOutputTableConfiguration"
  },

  SymbolWidthLoader = {
    ["path"] = "AC-ClientOutput/ClientOutput/Util/SymbolWidthLoader"
  },
  TabStopCalculator = {
    ["path"] = "AC-ClientOutput/ClientOutput/Util/TabStopCalculator"
  }
}


function TestClientOutputFactory:handleFactoryCreation(_function)

  local mockedTabWidth = math.random(2, 100)

  -- The ClientOutputFactory will create a TabStopCalculator on creation that is initialized with a value
  -- which is fetched by the SymbolWidthLoader

  -- A SymbolWidthLoader will be created
  self.dependencyMocks["SymbolWidthLoader"].__construct
    :should_be_called_with("FontDefault")
    :and_then(

      -- The character width of the character "\t" will be fetched
      self.dependencyMocks["SymbolWidthLoader"].getCharacterWidth
        :should_be_called_with("\t")
        :and_will_return(mockedTabWidth)
    )
    :and_then(

      -- A TabStopCalculator will be fetched with the character width of "\t"
      self.dependencyMocks["TabStopCalculator"].__construct
        :should_be_called_with(mockedTabWidth)
             )
    :and_then(
      self.dependencyMocks["ClientOutputConfiguration"].__construct
        :should_be_called_with(self.dependencyMocks["TabStopCalculator"])
             )
    :and_then(
      self.dependencyMocks["ClientOutputConfiguration"].parse
        :should_be_called_with(
          self.mach.match({
            maximumLineWidth = 3900,
            newLineIndent = "",
            lineSplitCharacters = " "
          }),
          true
                              )
             )
    :when(_function)

end

function TestClientOutputFactory:testReturnsSameInstanceOnConsecutiveCalls()

  local ClientOutputFactory = self.testClass

  local instance
  self:handleFactoryCreation(
    function()
      instance = ClientOutputFactory.getInstance()
    end
  )

  -- Check that the same instance is returned when the method is called a second time
  self.assertIs(instance, ClientOutputFactory.getInstance())

  -- Check that the same instance is returned when the method is called a third time
  self.assertIs(instance, ClientOutputFactory.getInstance())


  -- Create a new instance and check that the ClientOutputFactory instance does not equal the new instance
  local newInstance
  self:handleFactoryCreation(
    function()
      newInstance = ClientOutputFactory()
    end
  )
  self.assertNotIs(newInstance, ClientOutputFactory.getInstance())

end

function TestClientOutputFactory:testCanConfigureFontConfig()

  -- Check that the default value is used when nothing is configured
  --[[
    local clientOutputString = ClientOutputFactory.getInstance:getClientOutputString("output")

    luaunit.assertEquals("output", clientOutputString:getString())
    luaunit.assertEquals("FontDefault", clientOutputString:getSymbolWidthLoader())


    -- Check that the new font config value is used when configured
    ClientOutputFactory.getInstance():configure({
    ["fontConfig"] = "FontMono"
    })

    clientOutputString = ClientOutputFactory.getInstance:getClientOutputString("other-output")

    luaunit.assertEquals("other-output", clientOutputString:getString())
    luaunit.assertEquals("FontMono", clientOutputString:getSymbolWidthLoader())
  ]]
end


function TestClientOutputFactory:getFactoryInstance()

  local ClientOutputFactory = self.testClass

  local factory
  self:handleFactoryCreation(
    function()
      factory = ClientOutputFactory.getInstance()
    end
  )

  return factory

end


function TestClientOutputFactory:testCanCreateClientOutputString()

  local factory = self:getFactoryInstance()

  -- No configuration

  --[[
  self.dependencyMocks["ClientOutputConfiguration"].__construct
    :should_be_called_with(self.dependencyMocks["TabStopCalculator"])
    :and_then(
      self.dependencyMocks["ClientOutputConfiguration"].copyClientOutputConfiguration
        :should_be_called_with_any_arguments()
             )
    :and_then(
      self.dependencyMocks["ClientOutputString"].__construct
        :should_be_called_with(
          self.dependencyMocks["SymbolWidthLoader"],
          self.dependencyMocks["TabStopCalculator"],

                              )
             )
  --]]

  --factory:getClientOutputString("teststring")



  -- With configuration



  -- TODO: Check with no, partial and complete config

end

function TestClientOutputFactory:testCanCreateClientOutputTable()
  -- TODO: Check with no, partial and complete config
end

function TestClientOutputFactory:testCanChangeMaximumLineWidth()
end

function TestClientOutputFactory:testCanChangeNewLineIndent()
end

function TestClientOutputFactory:testCanChangeLineSplitCharacters()
end


return TestClientOutputFactory
