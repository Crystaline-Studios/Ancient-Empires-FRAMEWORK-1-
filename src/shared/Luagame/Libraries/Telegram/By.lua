local Compresser = {}

function Compresser:TableToString(Table)
	local Compressed = ""
	local Uncompressed = {}
	for Key, Value in pairs(Table) do
		local VType = typeof(Value)
		if VType == "BrickColor" then
			local NS = "/1/" .. Value.Number
			Compressed = Compressed .. NS ..  "|" .. tostring(Key)
		elseif VType == "CFrame" then
			local NS = "/2/"
			for _,Pos in ipairs({Value:GetComponents()}) do
				if NS == "/2/" then
					NS = NS .. Pos
				else
					NS = NS .. "|" .. Pos
				end
			end
			Compressed = Compressed .. NS ..  "|" .. tostring(Key)

		elseif VType == "Color3" then
			local NS = "/3/"
			NS = NS .. Value.R .. "|" .. Value.G .. "|" .. Value.B
			Compressed = Compressed .. NS ..  "|" .. tostring(Key)

		elseif VType == "Vector3" then
			local NS = "/4/"
			NS = NS .. Value.X .. "|" .. Value.Y .. "|" .. Value.Z
			Compressed = Compressed .. NS ..  "|" .. tostring(Key)

		elseif VType == "Vector2" then
			local NS = "/5/"
			NS = NS .. Value.X .. "|" .. Value.Y
			Compressed = Compressed .. NS ..  "|" .. tostring(Key) 


		elseif VType == "UDim2" then
			local NS = "/6/"
			NS = NS .. Value.X.Scale .. "|" .. Value.X.Offset .. "|" .. Value.Y.Scale .. "|" .. Value.Y.Offset
			Compressed = Compressed .. NS ..  "|" .. tostring(Key)


		elseif VType == "UDim" then
			local NS = "/7/"
			NS = NS .. Value.Scale .. "|" .. Value.Offset
			Compressed = Compressed .. NS ..  "|" .. tostring(Key)

		elseif VType == "string" then
			local NS = "/8/~-!"
			NS = NS  .. Value
			Compressed = Compressed .. NS .. "~-!" ..  "|" .. tostring(Key)

		elseif VType == "number" then
			local NS = "/9/"
			NS = NS  .. Value
			Compressed = Compressed .. NS ..  "|" .. tostring(Key)

		elseif VType == "table" then
			local NS = "/10/~-!"
			local String, NonCompressed =  Compresser:TableToString(Value)
			for _,D in pairs(NonCompressed) do
				table.insert(Uncompressed, D)
			end
			NS = NS  .. String
			Compressed = Compressed .. NS .. "~-!" ..  "|" .. tostring(Key)

		else
			table.insert(Uncompressed, Value)
		end

		return Compressed, Uncompressed
	end
end

-- Checks if a string is entirely numbers
function IsNumber(String)
	local FoundNonNumber = false
	for C = 1, string.len(String) do
		local Character = string.sub(String, C, C)
		if tonumber(Character) == nil then
			FoundNonNumber = true
		end
	end
	return not FoundNonNumber
end



function Compresser:Decompress(String)
	local Mode
	local ArgumentNumber = 0
	local Data
	local IsStringMode = false
	local StringProgressing = 0
	local RawData = {}

	-- Turns the string into more readable data
	for C = 1, string.len(String) do
		local Character = string.sub(String, C, C)
		local NCharacter = string.sub(String, C + 1, C + 1)
		local NNCharacter = string.sub(String, C + 2, C + 2)
		if not IsStringMode then
			if Mode == "Argument" and Character == "~" and  NCharacter == "-" and NNCharacter == "!" then
				IsStringMode = true
				StringProgressing += 1

			elseif Character == "/" then
				if Mode == "EndDType" then
					Mode = "Argument"
					ArgumentNumber += 1
				else
					Mode = "StartDType"
					ArgumentNumber = 0
				end

			elseif Character == "|" then
				ArgumentNumber += 1

			elseif IsNumber(Character) then
				if Mode == "StartDType" then
					RawData[#RawData+1] = {
						DType = Character,
						Data = {}}
					Data = RawData[#RawData].Data
				elseif Mode == "Argument" then
					if not Data[ArgumentNumber] then
						Data[ArgumentNumber] = Character
					else
						Data[ArgumentNumber] = Data[ArgumentNumber] .. Character
					end
				end


			else
				if not Data[ArgumentNumber] then
					Data[ArgumentNumber] = Character
				else
					Data[ArgumentNumber] = Data[ArgumentNumber] .. Character
				end
			end
		else
			if StringProgressing < 3 then
				StringProgressing += 1
			else
				if StringProgressing ~= 3 then
					StringProgressing += 1
					if StringProgressing == 6 then
						IsStringMode = false
					end
				else
					if Character == "~" and NCharacter == "-" and NNCharacter == "!" then
						StringProgressing += 1
					else
						Data[ArgumentNumber] = Data[ArgumentNumber] .. Character
					end
				end
			end
		end
	end

	local NData = {}
	for _,TData in pairs(RawData) do
		local DType = TData.DType
		local Data = TData.Data
		local Arguments = table.clone(Data); Arguments[#Arguments] = nil; Arguments = unpack(Arguments)
		local Key = Data[#Data]
		local HData
		if DType == "1" then
			HData = BrickColor.new(Arguments)
		elseif DType == "2" then
			HData = CFrame.new(Arguments)
		elseif DType == "3" then
			HData = Color3.new(Arguments)
		elseif DType == "4" then
			HData = Vector3.new(Arguments)
		elseif DType == "5" then
			HData = Vector2.new(Arguments)
		elseif DType == "6" then
			HData = UDim2.new(Arguments)
		elseif DType == "7" then
			HData = UDim.new(Arguments)
		elseif DType == "8" then
			HData = Arguments
		elseif DType == "9" then
			HData = tonumber(Arguments)
		elseif DType == "10" then
			HData = Compresser:Decompress(Arguments)
		end

		NData[Key] = HData
	end
	return NData
end

return Compresser