---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Exception = require "AC-ClientOutput.Util.Exception"

---
-- Exception for the case that operations on the input lines of a ClientOutputString are requested
-- before a string was parsed into the ClientOutputString.
--
-- @type Exception
--
local NoStringParsed = Exception:extend()


function NoStringParsed:getMessage()
  return "Cannot process input lines: No string parsed yet"
end


return NoStringParsed
