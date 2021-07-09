---
-- @author wesen
-- @copyright 2021 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains a list of substring position lists and provides methods to fetch a specific list.
--
-- @type ListCollection
--
local ListCollection = Object:extend()

---
-- The list of substring position lists
-- This list is in the format { <identifier> = <List>, ... }
--
-- @tfield List[] substringPositionLists
--
ListCollection.substringPositionLists = nil

---
-- The default substring position list that will be returned when no substring position list is found
-- for a given identifier
--
-- @tfield List nullSubstringPositionList
--
ListCollection.nullSubstringPositionList = nil


---
-- ListCollection constructor.
--
-- @tparam List _nullSubstringPositionList The substring position list to return when no substring position list is found for a given identifier
--
function ListCollection:new(_nullSubstringPositionList)
  self.nullSubstringPositionList = _nullSubstringPositionList
  self.substringPositionLists = {}
end


-- Public Methods

---
-- Adds a substring position list to this collection.
--
-- @tparam string _identifier The identifier of the new list
-- @tparam List _substringPositionList The substring position list
--
function ListCollection:addSubstringPositionList(_identifier, _substringPositionList)
  self.substringPositionLists[_identifier] = _substringPositionList
end

---
-- Returns the substring position list for a given identifier.
-- Will return the nullSubstringPositionList if no substring position list with that identifier exists.
--
-- @tparam string _identifier The identifier of the list to return
--
-- @tparam List The corresponding substring position list
--
function ListCollection:getSubstringPositionList(_identifier)

  local substringPositionList = self.substringPositionLists[_identifier]
  if (substringPositionList == nil) then
    return self.nullSubstringPositionList
  else
    return substringPositionList
  end

end


return ListCollection
