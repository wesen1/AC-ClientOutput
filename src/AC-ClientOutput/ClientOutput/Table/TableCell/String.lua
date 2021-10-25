---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local String = ClientOutputString:extend()

local StringSplitter = require "AC-ClientOutput.ClientOutput.ClientOutputString.StringSplitter"
local StringWidthCalculator = require "AC-ClientOutput.ClientOutput.ClientOutputString.StringWidthCalculator"


---
-- The tab stop calculator
--
-- @tfield TabStopCalculator tabStopCalculator
--
ClientOutputString.tabStopCalculator = nil

---
-- The tab stop calculator
-- This is used to calculate the maximum number of tabs from a maximum line width and vice versa
--
-- @tfield TabStopCalculator tabStopCalculator
--
ClientOutputBase.tabStopCalculator = nil


---
-- The string width calculator
--
-- @tfield StringWidthCalculator stringWidthCalculator
--
ClientOutputString.stringWidthCalculator = nil



-- @tparam SymbolWidthLoader _symbolWidthLoader The symbol width loader
-- @tparam TabStopCalculator _tabStopCalculator The tab stop calculator
function String:new(_stringWidthCalculator)

  self.tabStopCalculator = _tabStopCalculator
  self.stringWidthCalculator = StringWidthCalculator(_symbolWidthLoader, _tabStopCalculator)
  self.splitter = StringSplitter(self, _symbolWidthLoader, _tabStopCalculator)

  -- @tparam int|nil _padTabNumber The tab number until which the rows shall be padded with tabs (optional)

end


function LineSplitter:getParsedParentClientOutputString()

  if (not self.parsedString or
        self.parsedString:getLineSplitCharacters() ~= lineSplitCharacters or
      self.parsedString:getString() ~= self.parentClientOutputString:getString()) then

    -- The cached parsed string is not up to date, reparse the parent ClientOutputString

  end

  return self.parsedString

end




return String
