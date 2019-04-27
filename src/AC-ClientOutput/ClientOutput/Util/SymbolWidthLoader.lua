---
-- @author wesen
-- @copyright 2018-2019 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

---
-- Handles loading of symbol widths from one of the font tables
--
-- @type SymbolWidthLoader
--
local SymbolWidthLoader = setmetatable({}, {})


---
-- The font pixel widths in the format {[character] = width}
--
-- @tfield int[] fontConfig
--
SymbolWidthLoader.fontConfig = nil


---
-- SymbolWidthLoader constructor.
--
-- @tparam string _fontConfigFileName The font config file name
--
-- @treturn SymbolWidthLoader The SymbolWidthLoader instance
--
function SymbolWidthLoader:__construct(_fontConfigFileName)

  local instance = setmetatable({}, {__index = SymbolWidthLoader})
  instance.fontConfig = require("AC-ClientOutput/ClientOutput/FontConfig/" .. _fontConfigFileName)

  return instance

end

getmetatable(SymbolWidthLoader).__call = SymbolWidthLoader.__construct


-- Public Methods

---
-- Loads and returns the width of a character in pixels.
--
-- @tparam string _character The character
--
-- @treturn int The character width
--
function SymbolWidthLoader:getCharacterWidth(_character)

  local width = self.fontConfig[_character]
  if (width) then
    return width
  else
    return self.fontConfig["default"]
  end

end


return SymbolWidthLoader
