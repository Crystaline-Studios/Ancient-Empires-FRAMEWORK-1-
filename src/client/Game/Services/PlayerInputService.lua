-- Created by carrotoplia on 10/20/2022 12:01 PM
-- for easy usage of keyboard, mouse, and everything else input releated
-- also device information

----------------------------->> Modules and Services <<---------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")


----------------------------->> Assets and Variables <<---------------------------------

local AnyInputEvents = {}
local AnyInputGameEvents = {}
local AllInputEvents = {}
local AllInputGameEvents = {}

local InputEndEvents = {}
local InputEndGameEvents = {}


UserInputService.InputBegan:Connect(function(Input, IsGameProccessed)
	if AnyInputEvents[Input.KeyCode.Name] then
		AnyInputEvents[Input.KeyCode.Name]:Fire()
	end

	if not IsGameProccessed and AnyInputGameEvents[Input.KeyCode.Name] then
		AnyInputGameEvents[Input.KeyCode.Name]:Fire()
	end

	for Key, TInput in pairs(AllInputEvents) do
		if string.match(Key, Input.KeyCode.Name) then
			local IsHolding = true
			for _,SInput in pairs(TInput) do
				if not UserInputService:IsKeyDown(SInput) then
					IsHolding = false
				end
			end

			if IsHolding then
				TInput.Signal:Fire()
			end
		end
	end

	if not IsGameProccessed then
		for Key, TInput in pairs(AllInputGameEvents) do
			if string.match(Key, Input.KeyCode.Name) then
				local IsHolding = true
				for _,SInput in pairs(TInput) do
					if not UserInputService:IsKeyDown(SInput) then
						IsHolding = false
					end
				end

				if IsHolding then
					TInput.Signal:Fire()
				end
			end
		end
	end
end)

UserInputService.InputEnded:Connect(function(Input, IsGameProccessed)
	for Key, TInput in pairs(InputEndEvents) do
		if string.match(Key, Input.KeyCode.Name) then
			local IsHolding = true
			for _,SInput in pairs(TInput) do
				if not UserInputService:IsKeyDown(SInput) then
					IsHolding = false
				end
			end

			if IsHolding then
				TInput.Signal:Fire()
			end
		end
	end

	if IsGameProccessed then
		for Key, TInput in pairs(InputEndGameEvents) do
			if string.match(Key, Input.KeyCode.Name) then
				local IsHolding = true
				for _,SInput in pairs(TInput) do
					if not UserInputService:IsKeyDown(SInput) then
						IsHolding = false
					end
				end

				if IsHolding then
					TInput.Signal:Fire()
				end
			end
		end
	end
end)
----------------------------->> Service <<---------------------------------

local Service = {}
Service.Class = "PlayerInputService"

function Service:AllPressed(NotProccessed, ...)
	local Enums = {...}
	if #Enums == 0 then 
		error "No Enums?"
	end
	for _,Enum in pairs(Enums) do
		if typeof(Enum) == "Enum" then
			error "Non Enum value within AllPressed"
		end
	end

	if NotProccessed then
		local String = ""
		for _,Enum in pairs(Enums) do
			String = String .. Enum.Name .. "|"
		end
		if not AllInputGameEvents[String] then
			AllInputEvents[String] = Enums
		end
	else
		local String = ""
		for _,Enum in pairs(Enums) do
			String = String .. Enum.Name .. "|"
		end
		if not AllInputGameEvents[String] then
			AllInputGameEvents[String] = Enums
		end
	end
end

function Service:AnyPressedEvent(NotProccessed, ...)
	local Enums = {...}
	if #Enums == 0 then 
		error "No Enums?"
	end
	for _,Enum in pairs(Enums) do
		if typeof(Enum) == "Enum" then
			error "Non Enum value"
		end
	end

	if NotProccessed then
		local String = ""
		for _,Enum in pairs(Enums) do
			String = String .. Enum.Name .. "|"
		end
		if not AllInputGameEvents[String] then
			AllInputEvents[String] = Enums
		end
	else
		local String = ""
		for _,Enum in pairs(Enums) do
			String = String .. Enum.Name .. "|"
		end
		if not AllInputGameEvents[String] then
			AllInputGameEvents[String] = Enums
		end
	end
end

function Service:AnyReleaseEvent(NotProccessed, ...)
	local Enums = {...}
	if #Enums == 0 then 
		error "No Enums?"
	end
	for _,Enum in pairs(Enums) do
		if typeof(Enum) == "Enum" then
			error "Non Enum value"
		end
	end

	if NotProccessed then
		local String = ""
		for _,Enum in pairs(Enums) do
			String = String .. Enum.Name .. "|"
		end
		if not AllInputGameEvents[String] then
			AllInputEvents[String] = Enums
		end
	else
		local String = ""
		for _,Enum in pairs(Enums) do
			String = String .. Enum.Name .. "|"
		end
		if not AllInputGameEvents[String] then
			AllInputGameEvents[String] = Enums
		end
	end
end


return Service