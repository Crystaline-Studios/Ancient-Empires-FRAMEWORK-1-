-- Created By Carrotoplia on Mon Oct 10 18:11:51 2022
-- Used to quickly wrap up tables for use so they error

----------------------------->> Services and Modules <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Table = require(Get("Table"))

----------------------------->> Objectify <<---------------------------------

return function(Name)
	assert(Name, "Missing First Parameter: Put a string as name or a table and that would set it to be the Object")

	local Object = if type(Name) ~= "table" then {Name = Name} else Name
	local Data = {}
	local Meta = {}

	function Object:SetReadable(Index, Bool)
		assert(Index, "Missing Parameter: Index")
		assert(Bool, "Missing Parameter: Bool")
		assert(typeof(Bool) == "boolean", "Bool Expected got" .. typeof(Bool))

		if not Data[Index] then
			Data[Index] = {}
		end

		Data[Index].Readable = Bool
	end
	function Object:SetChangable(Index, Bool)
		assert(Index, "Missing Parameter: Index")
		assert(Bool, "Missing Parameter: Bool")
		assert(typeof(Bool) == "boolean", "Bool Expected got" .. typeof(Bool))

		if not Data[Index] then
			Data[Index] = {}
		end

		Data[Index].Readable = Bool
	end
	function Object:SetDatatype(Index, Type)
		assert(Index, "Missing Parameter: Index")
		assert(Type, "Missing Parameter: Type")
		assert(typeof(Type) == "boolean", "Type Expected got" .. typeof(Type))

		if not Data[Index] then
			Data[Index] = {}
		end

		Data[Index].Type = Type
	end



	function Object:BindProperty(Source, PropertyName, Name)
		if not Data[Name or PropertyName] then
			Data[Name or PropertyName] = {}
		end
		Data[Name or PropertyName].BindedTo = Source
		Data[Name or PropertyName].BindedPName = PropertyName
	end

	local OldIndexFunction
	function Meta:__index(_, Index, ...)
		local IndexD = Data[Index]
		if not IndexD or not IndexD.Readable == false then
			if IndexD and IndexD.BindedTo then
				return IndexD.BindedTo[IndexD.BindedPName]
			else
				if OldIndexFunction then
					return OldIndexFunction(_, Index, ...)
				else
					return rawget(Object, Index)
				end
			end
		else
			error("Attempted to index" .. tostring(rawget(Object, "Name")) or "Object" .. "with" .. Index)
		end
	end

	local OldNewIndexFunction
	function Meta:__newindex(Index, NewValue, ...)
		local SData = Data[Index]
		local BindProperty = SData.BindedPName
		local BindSource = SData.Bindedto
		local Type = typeof(NewValue)
		local DataType = SData.Type

		if SData and SData.Changable then
			if not SData.Type then
				if BindSource then
					SData.BindedTo[BindProperty] = NewValue
				else
					if not OldNewIndexFunction then
						Object[Index] = NewValue
					else
						OldNewIndexFunction(Index, NewValue, ...)
					end
				end
			end
		else
			if DataType == Type or Type == "Table" and Type.__type == DataType then
				if BindSource then
					BindSource[BindProperty] = NewValue
				else
					if not OldNewIndexFunction then
						Object[Index] = NewValue
					else
						OldNewIndexFunction(Index, NewValue, ...)
					end
				end
			else
				local Type = if Type == "Table" then 
					Type.__type or Type.Class or Type 
				else 
					Type

				error("Incorrect Type. " .. DataType .. " Was Expected Got" .. Type)
			end
		end

		error("Attempted to Set and failed this property is likely nonchangable")
	end


	if type(Name) == "table" then
		if getmetatable(Object) then
			local OldMeta = getmetatable(Object)
			OldNewIndexFunction = OldMeta.__newindex
			OldIndexFunction = OldMeta.__index
		end

		setmetatable(Object, Meta)
		return Object
	else
		return Object, function()
			if not Object.Class then
				warn("Missing class property")
			end
	
			if getmetatable(Object) then
				local OldMeta = getmetatable(Object)
				OldNewIndexFunction = OldMeta.__newindex
				OldIndexFunction = OldMeta.__index
			end
	
			setmetatable(Object, Meta)
		end
	end
end


-- Old Version for safe keeping
--[[
return function(Table, Config)
	if not Table.Class and not Config
		or not Table.Class and not Config.Classless then
		error("YO THIS TABLE MISSING A CLASS PROPERTY")
	end
	
	----------------------------->> Variables <<---------------------------------
	
	local ChangableProperties = {}
	local BindedProperties = {}
	local HiddenProperties = {}
	
	----------------------------->>  <<---------------------------------
	
	local Holder = {}
	
	function Holder:SetChangable(ID, Type)
		ChangableProperties[ID] = {Type}
	end

	function Holder:SetHidden(ID)
		ChangableProperties[ID] = true
	end
	function Holder:BindToProperty(Table, PropertyName, Name)
		BindedProperties[Name or PropertyName] = Table
	end
	
	local Metatable = {}
	local OldIndex
	local OldNewIndex
	Metatable.__index = function(Key, Index, ...)
		if HiddenProperties[Index] then
			error("Attempted to Index object with: '" .. Index .. "' (hidden property)")
		else
			if not OldIndex then
				return rawget(Table,Index)
				
				
			elseif BindedProperties[Index] then
				return BindedProperties[Index][Index]
				
			else
				if type(OldIndex) == "function" then
					return OldIndex(Key, Index, ...)
				else
					return OldIndex[Key]
				end
			end
		end
	end
	Metatable.__newindex = function(Index, NewValue)
		if not HiddenProperties[Index] then
			local ChangeProperty = ChangableProperties[Index]
			if ChangeProperty and not ChangeProperty[1] or ChangeProperty and ChangeProperty[1] == typeof(NewValue) then
				if not OldNewIndex then
					if BindedProperties[Index] then
						BindedProperties[Index][Index] = NewValue
					else
						rawset(Table, Index, NewValue)
					end
				else
					OldNewIndex(Index, NewValue)
				end
			else
				error("Attempted to Set Read Only Property with: '" .. tostring(NewValue) .. "'")
			end
		else
			error("Attempted to Set Hidden Property with: '" .. tostring(NewValue) .. "'")
		end
	end
	if getmetatable(Table) then
		local OMeta = getmetatable(Table)
		if OMeta.__index ~= nil then
			OldIndex = OMeta.__index
		end
		if OMeta.__newindex ~= nil then
			OldNewIndex = OMeta.__newindex
		end
	end
	Metatable.__metatable = true
	setmetatable(Table, Metatable)
	
	return Holder
end
]]