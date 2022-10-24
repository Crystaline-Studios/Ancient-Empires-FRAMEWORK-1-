--Created By Carrotoplia on Tue Oct 11 12:52:50 2022
-- Used for storing objects with an ID.

----------------------------->> Assets <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Signal = require(Get("QuickSignal")).new()
local Objectify = require(Get("Objectify"))

----------------------------->> Library <<---------------------------------
local Library = {}
local Storage = {}

Library.Class = "ObjectStoreLibrary"
Library.class = Library.Class

function Library:NewStore(ID, DTable)
	assert(ID, "Missing Parameter: ID")
	if Storage[ID] then
		Storage[ID].Overridden = true
	end
	local Store = {}
	Store.Data = DTable or {}
	
	function Store:Wipe()
		if Storage[ID] == Store then
			Storage[ID] = nil
		end
	end
	Store.wipe = Store.Wipe
	
	setmetatable(Store, {__index = Store.Data})
	local Holder = Objectify(Store, {Classless = true})
	Storage[ID] = Store
	Signal:Fire(ID)
	return Store
end
Library.newstore = Library.NewStore
Library.newStore = Library.NewStore


function Library:GetStore(ID)
	assert(ID, "Missing Property: ID")
	if Storage[ID] ~= nil then
		return Storage[ID]
	else
		error("Attempted to Get Nil Storage")
	end
end
Library.getstore = Library.GetStore
Library.getStore = Library.GetStore


function Library:WaitForStore(ID)
	assert(ID, "Missing Property: ID")
	if Storage[ID] ~= nil then
		return Storage[ID]
	else
		Signal:WaitWithCheck(function(NID)
			if ID == NID then 
				return true
			end
		end)
		return Storage[ID]
	end
end
Library.waitforstore = Library.WaitForStore
Library.waitForStore = Library.WaitForStore


local Holder = Objectify(Library)
return Library