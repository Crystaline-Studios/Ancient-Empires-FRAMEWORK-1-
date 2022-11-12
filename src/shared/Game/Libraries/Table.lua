
--[=[
	@class TableLibrary

	Used to configure anything thats in the shared folder.
]=]
local Get = require(game:GetService("ReplicatedStorage").Get)
local GoodSignal = require(Get("GoodSignal"))



local Library = {}
setmetatable(Library, {
	__index = table
})
Library.Class = "TableLibrary"

--[=[
	@within TableLibrary
	Returns EVERYTHING it can find(in a new table)
	its like :GetDescendants but with tables!

	@param Table table -- The table to search through
]=]
function Library.Index(Table)
	local Indexes = {}
	local function Loop(T)
		for _,V in pairs(T) do
			table.insert(Indexes, V)
			if type(V) == "table" then
				Loop(V)
			end
		end
	end
	Loop(Table)

	return Indexes
end

--[=[
	@within TableLibrary
	its like table.find but with every table inside that table and inside that tabl...

	@param Table table -- The table to search through
	@param FunctionValue any -- The value your looking for
]=]
function Library.superfind(Table, FunctionValue)
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
	Loop(Table)

	return Source, VKey
end
Library.SuperFind = Library.superfind

--[=[
	@within TableLibrary
	Combines all the tables and returns one new "supertable"

	@param ... turple -- All the tables you can shove in here!
]=]
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


--[=[
	@within TableLibrary
	very clean way to get a random value from a table

	@param Table table -- Table to get a random value from
]=]
function Library.Random(Table)
	local Index = Library.Index(Table)
	return Index[math.random(1, #Index)]
end
Library.random = Library.Random


local Metatable = {}
Metatable.OnChange = GoodSignal.new()
Metatable.OnCall = GoodSignal.new()
Metatable.IndexChangedEvents = {}
Metatable.HiddenIndexes = {}
Metatable.Typelock = {}
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

function gettype(Input)
	local Types = {Input, typeof(Input)}
	if type(Input) == "table" then
		if Input.Class then
			table.insert(Types, Input.Class)
		end
		if Input.__type then
			table.insert(Types, Input.__type)
		end
	end

	return Types
end

function Metatable:__newindex(table, Index, Value)
	local IsRightType = true
	if self.Typelock[Index] then
		IsRightType = false
		for _,Type in pairs(gettype(Value)) do
			if self.Typelock[Type] then
				IsRightType = true
				break
			end
		end
	end

	if IsRightType then
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
	else
		warn(self.Typelock[Index])
		error("Incorrect datatype for Index Accepted Value(s) above.")
	end
end
function Metatable:__call(...)
	self.OnCall:Fire(...)
end

--[=[
	@within TableLibrary
	Makes an Index attempt error when attempted to be read or set.

	@param Table table -- Table to set the index hidden
	@param Index any -- Da Index
]=]
function Library.HideIndex(Table, Index)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	Meta.HiddenIndexes[Index] = true
end

--[=[
	@within TableLibrary
	Makes an index only be changable to specific values
	it has to EQUAL to any of the type values and it checks the following out of the input
	Input.Class, Input.__type, typeof(Input)

	@param Table table -- Table to set the index hidden
	@param Index any -- Da Index
	@param Types table -- List of types thats allowed
]=]
function Library.SetDatatypes(Table, Index, Types)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	Meta.Typelock[Index] = Types
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
function Library.GetKeyChangedEvent(Table, Index)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end
	if not Meta.IndexChangedEvents[Index] then
		Meta.IndexChangedEvents[Index] = GoodSignal.new()
	end

	return Meta.IndexChangedEvents[Index]
end
function Library.OnCall(Table)
	local Meta = getmetatable(Table)
	if not Metatable then
		setmetatable(Table, table.clone(Metatable))
		Meta = getmetatable(Table)
	end

	return Meta.OnCall
end

return Library