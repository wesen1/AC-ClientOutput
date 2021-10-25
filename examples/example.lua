---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

--
-- Add the path to the AC-ClientOutput classes to the package path list
-- in order to be able to omit this path portion in require() calls
--
package.path = package.path .. ";../src/?.lua"

local ClientOutputFactory = require "AC-ClientOutput.ClientOutputFactory"

local clientOutputFactory = ClientOutputFactory.getInstance()

clientOutputFactory:configure({
  fontConfigFileName = "FontDefault",
  maximumLineWidth = 600
})


print("ClientOutputString:\n")
local clientOutputString = clientOutputFactory:getClientOutputString(
  "hello world 123, 1234567890"
)

for _, row in ipairs(clientOutputString:getOutputRows()) do
  print(row)
end



clientOutputFactory:configure({
  maximumLineWidth = 2000
})

print("\n\nClientOutputTable:\n")
local clientOutputTable = clientOutputFactory:getClientOutputTable(
  {
    {
      "row 1",
      ""
    },
    {
      "long different text for test",
      "r2f2"
    },
    {
      "r3f1",
      "long different text for test"
    }
  }
)

for _, row in ipairs(clientOutputTable:getOutputRows()) do
  print(row)
end
