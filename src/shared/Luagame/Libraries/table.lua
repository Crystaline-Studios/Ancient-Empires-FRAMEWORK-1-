-- Gives changed events for tables!
-- by carrotoplia

----------------------------->> Modules and Services <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Object = require(Get("Object"))
local Signal = require(Get("QuickSignal"))

----------------------------->> Library <<---------------------------------

local Library, Finalize = Object "Table Library"
setmetatable(Library, {
	__index = table
})
Library.Class = "TableLibrary"
Library.class = Library.Class




function Library:GetChangedEvent(Table)
	local Metatable = getmetatable(Table)
	
	if Metatable.__ChangedEvent then
		return Metatable.__ChangedEvent
	else
		local Meta = {
			__ChangedEvent = Signal.new(),
			
			__newindex = function(Index,Value)
				local OldValue = rawget(Table, Index, Value)
				if Metatable and Metatable.__newindex then
					if typeof(Metatable.__newindex) == "function" then
						Metatable.__newindex(Index,Value)
						if rawget(Table, Index) == Value and rawget(Table, Index) ~= OldValue then
							Metatable.__ChangedEvent:Fire(Index,Value,OldValue)
						end
					else
						error("Unknown Type in newindex")
					end
				else
					rawset(Table, Index, Value)
					if rawget(Table, Index) == Value and rawget(Table, Index) ~= OldValue then
						Metatable.__ChangedEvent:Fire(Index,Value,OldValue)
					end
				end
			end,
		}	
		setmetatable(Table, Meta)
	end
end

function Library:WaitForIndex(Table, Index)
	local Changed = Library:GetChangedEvent(Table)
	Changed:WaitWithCheck(function(NIndex, Value)
		if NIndex == Index then
			return true
		end
	end)
	return Table[Index]
end

function Library:OnCall(T, F)
	if getmetatable(T) == nil then
		setmetatable(T, {__call = F})
	else
		getmetatable(T)["__call"] = F
	end
end


function Library.merge(...)
	local Tables = {...}
	local SuperTable = {}
	for SuperKey, Table in (Tables) do
		for Key,Value in (Table) do
			if type(Key) ~= "number" then
				SuperTable[Key] = Value
			else
				table.insert(SuperTable, Value)
			end
		end
	end
	return SuperTable
end
Library.Merge = Library.merge

function Library.Random(T)
	return T[math.random(1,#T)]
end
Library.random = Library.Random

Finalize()
return Library