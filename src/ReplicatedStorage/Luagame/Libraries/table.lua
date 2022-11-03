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
	
	if Metatable and not Metatable.__ChangedEvent or not Metatable then
		local Meta = {}
		
		Meta.__ChangedEvent = Signal.new()
		Meta.__IndexChangedEvents = {}

		function Meta:__newindex(Index, Value)
			local OldValue = rawget(Table, Index)

			if Metatable and Metatable.__newindex then
				if typeof(Metatable.__newindex) == "function" then
					Metatable.__newindex(Index,Value)
					local CurrentValue = rawget(Table, Index)

					if CurrentValue == Value and rawget(Table, Index) ~= OldValue then
						Meta.__ChangedEvent:Fire(Index, Value, OldValue)

						if Meta.__IndexChangedEvents[Index] then
							Meta.__IndexChangedEvents[Index]:Fire(Value, OldValue)
						end
					end
				else
					error("Unknown Type in newindex")
				end
			else
				rawset(Table, Index, Value)
				if rawget(Table, Index) == Value and rawget(Table, Index) ~= OldValue then
					Meta.__ChangedEvent:Fire(Index,Value,OldValue)

					if Meta.__IndexChangedEvents[Index] then
						Meta.__IndexChangedEvents[Index]:Fire(Value, OldValue)
					end
				end
			end
		end
		setmetatable(Table, Meta)
	end

	return getmetatable(Table).__ChangedEvent
end

function Library:GetIndexChangedEvent(Table, Index)
	Library:GetChangedEvent(Table)
	local Meta = getmetatable(Table)

	if not Meta.__IndexChangedEvents[Index] then
		Meta.__IndexChangedEvents[Index] = Signal.new()
	end

	return Meta.__IndexChangedEvents[Index]
end

function Library:GetIndexes(T)
	local Indexes = {}
	local function Loop(T)
		for _,V in pairs(T) do
			table.insert(Indexes, V)
			if type(V) == "table" then
				Loop(V)
			end
		end
	end

	return Indexes
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