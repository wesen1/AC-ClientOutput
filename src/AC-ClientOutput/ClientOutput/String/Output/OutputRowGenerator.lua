---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

---
-- Splits input lines into output rows based on the maxium width setting.
--
-- @type InputLineSplitter
--
local InputLineSplitter = {}


---
-- The output row builder
--
-- @tfield OutputRowBuilder outputRowBuilder
--
InputLineSplitter.outputRowBuilder = nil


---
-- LineSplitter constructor.
--
-- @tparam OutputRowBuilder _outputRowbuilder The output row builder
--
function InputLineSplitter:new(_outputRowBuilder)
  self.outputRowBuilder = _outputRowBuilder
end


-- Public Methods

---
-- Splits a line into output rows.
--
-- @tparam string _line The line
--
-- @treturn string[] The output rows
--
function InputLineSplitter:splitIntoOutputRows(_line)

  local parsedLine = self.parser:parse(_line)
  self.outputRowBuilder:initialize(parsedLine)

  local outputRows = {}
  local nextRow

  local remainingLine = _line
  while (#remainingLine > 0) do
    nextRow, remainingLine = self.outputRowBuilder:buildNextRow(_line, stringPosition)
    table.insert(outputRows, nextRow)
  end

  --[[
  while (not self.outputRowBuilder:isFinished()) do

    self.outputRowBuilder:parseNextCharacter()
    if (self.outputRowBuilder:isMaximumLineWidthReached()) then
      table.insert(outputRows, self.rowBuilder:buildNextRow(false))
    elseif (self.outputRowBuilder:isFinished()) then
      table.insert(outputRows, self.rowBuilder:buildNextRow(true))
    end

  end
  --]]

  return outputRows

end


return InputLineSplitter
