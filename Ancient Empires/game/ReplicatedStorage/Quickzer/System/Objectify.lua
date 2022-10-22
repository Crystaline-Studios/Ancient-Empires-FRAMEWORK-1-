--Created By Carrotoplia on Mon Oct 10 18:11:51 2022
-- Used to quickly wrap up tables for use by the player

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