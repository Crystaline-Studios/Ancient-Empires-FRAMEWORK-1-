----------------------------->> Modules and Services <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local QuickSignal = require(Get("QuickSignal"))

----------------------------->> Library <<---------------------------------

local Library = {}
setmetatable(Library, {
	__index = table
})
Library.Class = "TableLibrary"

function Library.Index(T)
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

function Library.superfind(T, FunctionValue)
	local VKey 
	local Source
	local function Loop(T)
		for Key, KeyValue in pairs(T) do
			if FunctionValue == KeyValue then
				VKey = Key
				Source = T
				break
			elseif type(KeyValue) == "table" then
				Loop(KeyValue)
			end
		end
	end
	Loop(T)

	return Source, VKey
end

-- TODO REDO
function Library:WaitForIndex(Table, Index)
	local Changed = Library:GetChangedEvent(Table)
	return Changed:WaitWithCheck(function(NIndex, Value)
		if NIndex == Index then
			return true
		end
	end)
end


function Library.merge(...)
	local Tables = {...}
	local SuperTable = {}
	for _, Table in (Tables) do
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


local Metatable = {}
Metatable.OnChange = QuickSignal.new()
Metatable.OnCall = QuickSignal.new()
Metatable.IndexChangedEvents = {}
Metatable.HiddenIndexes = {}
Metatable.LockedIndexes = {}

function Metatable:__index(table, Key)
	if not self.HiddenIndexes[Key] then
		if self.IndexFunction then
			return self.IndexFunction(table, Key)
		else
			return rawget(table, Key)
		end
	else
		error("Attempted to read hidden index.")
	end
end
function Metatable:__newindex(table, Index, Value)
	if not self.LockedIndexes[Index] then
		if not self.HiddenIndexes[Index] then
			if self.ChangeFunction then
				self.ChangeFunction(table, Index, Value)
				if rawget(table, Index) == Value then
					self.OnChange:Fire(Index, Value)
					if self.IndexChangedEvents[Index] then
						self.IndexChangedEvents[Index]:Fire(Value)
					end
				end
			else
				rawset(table, Index, Value)
				self.OnChange:Fire(Index, Value)
				if self.IndexChangedEvents[Index] then
					self.IndexChangedEvents[Index]:Fire(Value)
				end
			end
		else
			error("Attempted to set hidden index.")
		end
	else
		error("Attempted to set locked index.")
	end
end
function Metatable:__call(...)
	self.OnCall:Fire(...)
end


function Library.HideIndex(Table, Index)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	Meta.HiddenIndexes[Index] = true
end
function Library.LockIndex(Table, Index)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	Meta.LockedIndexes[Index] = true
end

function Library.SetIndexHandler(Table, Function)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	Meta.IndexFunction = Function
end
function Library.SetChangeHandler(Table, Function)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	Meta.NewIndexFunction = Function
end
function Library.GetChangedEvent(Table)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	return Meta.OnChange
end
function Library.GetIndexChangedEvent()
	
end

return Library