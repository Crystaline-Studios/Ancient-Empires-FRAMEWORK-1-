local Service = {}

function Service.New(Table)
	local ScreenGui = Instance.new('ScreenGui')
	local ToIterate = {table.clone(Table)}
	ToIterate[1].Instance = ScreenGui

	while #ToIterate > 0 do
		for _, Value in pairs(ToIterate) do
			for TableKey, TableValue in pairs(Value) do
				if TableKey == "Children" then
					for Key, Child in pairs(TableValue) do
						Child.Instance = Instance.new(string.split(Key, "_")[1])
						Child.Instance.Parent = Value.Instance
					end
				elseif TableKey == "Properties" then
					for PropertyName, PropertyValue in pairs(TableValue) do

						if PropertyName == "Size" then
							if typeof(Value.Instance.Size) == "UDim2" then
								assert(type(PropertyValue) == "table", "Incorrect Datatype, table expected.")
								assert(PropertyValue.X, "Missing Parameter: Value.X")
								assert(PropertyValue.Y, "Missing Parameter: Value.Y")

								Value.Instance[PropertyName] = UDim2.new(PropertyValue.X, 0, PropertyValue.Y, 0)
							end
						elseif PropertyName == "Position" then
							if typeof(PropertyName) == "UDim2" then
								assert(type(PropertyValue) == "table", "Incorrect Datatype, table expected.")
								assert(PropertyValue.X, "Missing Parameter: Value.X")
								assert(PropertyValue.Y, "Missing Parameter: Value.Y")

								NewValue = UDim2.new(PropertyValue.X, 0, PropertyValue.Y, 0)
								Value.Instance["AnchorPoint"] = Vector2.new(PropertyValue.X, PropertyValue.Y)
							end
						end

						if NewValue then
							Value.Instance[PropertyName] = NewValue
						end
					end
				end
			end
		end
	end
end

return Service