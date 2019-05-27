---
-- @author wesen
-- @copyright 2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local TestCase = require("TestFrameWork/TestCase")

---
-- Checks that the SymbolWidthLoader class works as expected.
--
-- @type TestSymbolWidthLoader
--
local TestSymbolWidthLoader = {}


---
-- The require path for the class that is tested by this TestCase
--
-- @tfield string testClassPath
--
TestSymbolWidthLoader.testClassPath = "AC-ClientOutput/ClientOutput/Util/SymbolWidthLoader"

---
-- The paths to the available font configs
-- This is used to mock specific font configs during the tests
--
-- @tfield string[] fontConfigPaths
--
TestSymbolWidthLoader.fontConfigPaths = {
  FontDefault = "AC-ClientOutput/ClientOutput/FontConfig/FontDefault",
  FontMono = "AC-ClientOutput/ClientOutput/FontConfig/FontMono",
  FontSerif = "AC-ClientOutput/ClientOutput/FontConfig/FontSerif"
}


---
-- Mocks one of the font config files.
--
-- @tparam string _fontConfigFileName The name of the font config file
-- @tparam int[] _mockedFontConfig The mocked font config
--
function TestSymbolWidthLoader:mockFontConfig(_fontConfigFileName, _mockedFontConfig)
  local fontConfigPath = self.fontConfigPaths[_fontConfigFileName]
  package.loaded[fontConfigPath] = _mockedFontConfig
end

---
-- Method that is executed after each test.
--
function TestSymbolWidthLoader:tearDown()

  TestCase.tearDown(self)

  -- Unload the mocked font configs
  for _, fontConfigPath in pairs(self.fontConfigPaths) do
    package.loaded[fontConfigPath] = nil
  end

end


---
-- Checks that the SymbolWidthLoader can return the defined character widths.
--
function TestSymbolWidthLoader:testCanGetDefinedCharacterWidth()

  local SymbolWidthLoader = self.testClass

  for _, testValueSet in ipairs(self:canGetDefinedCharacterWidthProvider()) do

    local character = testValueSet["character"]
    local characterWidth = testValueSet["width"]

    self:mockFontConfig("FontDefault", { [character] = characterWidth, ["default"] = 5 })

    local symbolWidthLoader = SymbolWidthLoader("FontDefault")
    self.assertEquals(symbolWidthLoader:getCharacterWidth(character), characterWidth)

  end

end

---
-- Data provider for TestSymbolWidthLoader:testCanGetDefinedCharacterWidth().
--
function TestSymbolWidthLoader:canGetDefinedCharacterWidthProvider()

  return {
    { ["character"] = "a", ["width"] = 20 },
    { ["character"] = "~", ["width"] = 31 },
    { ["character"] = "f", ["width"] = 10 },
    { ["character"] = "g", ["width"] = 45 },
    { ["character"] = "z", ["width"] = 38 }
  }

end

---
-- Checks that the SymbolWidthLoader can fall back to the default width if no character width is defined.
--
function TestSymbolWidthLoader:testCanGetUndefinedCharacterWidth()

  local SymbolWidthLoader = self.testClass

  for _, testValueSet in ipairs(self:canGetUndefinedCharacterWidthProvider()) do

    local character = testValueSet["character"]

    self:mockFontConfig("FontDefault", testValueSet["fontConfig"])

    local symbolWidthLoader = SymbolWidthLoader("FontDefault")
    self.assertEquals(symbolWidthLoader:getCharacterWidth(character), testValueSet["expectedWidth"])

  end

end

---
-- Data provider for TestSymbolWidthLoader:testCanGetUndefinedCharacterWidth().
--
function TestSymbolWidthLoader:canGetUndefinedCharacterWidthProvider()

  return {
    { ["character"] = "b", ["fontConfig"] = { ["a"] = 10, ["default"] = 24 }, ["expectedWidth"] = 24 },
    { ["character"] = "*", ["fontConfig"] = { ["b"] = 23, ["default"] = 26 }, ["expectedWidth"] = 26 },
    { ["character"] = "t", ["fontConfig"] = { ["j"] = 41, ["default"] = 36 }, ["expectedWidth"] = 36 },
    { ["character"] = "-", ["fontConfig"] = { ["+"] = 22, ["default"] = 21 }, ["expectedWidth"] = 21 },
    { ["character"] = "y", ["fontConfig"] = { ["x"] = 31, ["default"] = 33 }, ["expectedWidth"] = 33 }
  }

end

---
-- Checks that the SymbolWidthLoader can correctly load a specified font config.
--
function TestSymbolWidthLoader:testCanLoadFontConfig()

  local SymbolWidthLoader = self.testClass

  for _, testValueSet in ipairs(self:canLoadFontConfigProvider()) do

    -- Mock every of the font configs
    for fontConfigName, _ in pairs(self.fontConfigPaths) do
      self:mockFontConfig(fontConfigName, testValueSet[fontConfigName])
    end

    -- Create a SymbolWidthLoader that loads one of the font configs
    local symbolWidthLoader = SymbolWidthLoader(testValueSet["targetFontConfig"])

    -- Check that the SymbolWidthLoader returns the widths of the target font config
    for character, expectedWidth in pairs(testValueSet["testCharacters"]) do
      self.assertEquals(symbolWidthLoader:getCharacterWidth(character), expectedWidth)
    end

  end

end

---
-- Data Provider for TestSymbolWidthLoader:testCanLoadFontConfig().
--
function TestSymbolWidthLoader:canLoadFontConfigProvider()

  return {
    -- Test set A
    {
      ["FontDefault"] = { ["default"] = 1000 },
      ["FontMono"] = { ["default"] = 200 },
      ["FontSerif"] = {
        ["a"] = 10,
        ["b"] = 15,
        ["g"] = 20,
        ["default"] = 37
      },

      ["targetFontConfig"] = "FontSerif",

      ["testCharacters"] = {
        ["a"] = 10,
        ["b"] = 15,
        ["c"] = 37,
        ["d"] = 37,
        ["e"] = 37,
        ["f"] = 37,
        ["g"] = 20,
        ["+"] = 37,
        ["*"] = 37,
        ["u"] = 37
      }
    },

    -- Test set B
    {
      ["FontDefault"] = { ["default"] = 1234 },
      ["FontMono"] = {
        ["c"] = 70,
        ["f"] = 71,
        ["h"] = 73,
        ["l"] = 12,
        ["+"] = 45,
        ["#"] = 31,
        ["default"] = 41
      },
      ["FontSerif"] = { ["default"] = 9999 },

      ["targetFontConfig"] = "FontMono",

      ["testCharacters"] = {
        ["a"] = 41,
        ["b"] = 41,
        ["c"] = 70,
        ["d"] = 41,
        ["e"] = 41,
        ["f"] = 71,
        ["g"] = 41,
        ["h"] = 73,
        ["i"] = 41,
        ["j"] = 41,
        ["k"] = 41,
        ["l"] = 12,
        ["+"] = 45,
        ["#"] = 31,
        ["~"] = 41,
        ["*"] = 41,
        ["["] = 41
      }
    }
  }

end


-- TestSymbolWidthLoader inherits methods and attributes from TestCase
setmetatable(TestSymbolWidthLoader, {__index = TestCase})


return TestSymbolWidthLoader
