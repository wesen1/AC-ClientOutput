---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

-- Script to execute on a AssaultCube Lua server to see if the calculated widths really match
-- the actual displayed texts widths.

local combinations = {

  -- Assume that one character can only have a integer width

  -- For comparison reasons the number of whitespaces is the same in every check

  -- The following tests check whether a whitespace has the same width as some character
  -- The calculation is:
  --   whitespace width * amount whitespaces - compare character width * amount compare characters = 0?
  -- And since whitespace width "=" compare character width you can simplify it as this:
  --   whitespace width = compare character width?

  -- Compare a number of whitespaces to the same number of characters with a width of 38 pixels
  { ["name"] = "Whitespace = 38 pixels?", ["whitespace"] = 37, ["compareString"] = string.rep("@", 37)},

  -- Compare a number of whitespaces to the same number of characters with a width of 37 pixels
  { ["name"] = "Whitespace = 37 pixels?", ["whitespace"] = 37, ["compareString"] = string.rep("+", 37) },


  -- The following checks compare a number of whitespaces with a number of other characters with the
  -- same width as the number of whitespaces
  -- The calculation is:
  --   whitespace width * amount whitespaces - compare character width * amount compare characters = 0?
  -- And since amount whitespaces = amount compare characters you can simplify it as this:
  --   whitespace width = amount compare characters?

  { ["name"] = "Whitespace = 36 pixels?", ["whitespace"] = 37, ["compareString"] = string.rep("+", 36), ["shouldMatch"] = true },

  { ["name"] = "Whitespace = 35 pixels?", ["whitespace"] = 37, ["compareString"] = string.rep("+", 35) },

  { ["name"] = "Whitespace = 34 pixels?", ["whitespace"] = 37, ["compareString"] = string.rep("+", 34) }
}

for _, combination in ipairs(combinations) do

  local prependString = ""
  if (combination["shouldMatch"]) then
    prependString = "* "
  end

  self.output:print(prependString .. combination["name"])
  self.output:print(string.rep(" ", combination["whitespace"]) .. "______")
  self.output:print(combination["compareString"] .. "______")
  self.output:print("\n")

end
