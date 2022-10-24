-- Created By Carrotoplia on Sun Oct  9 20:07:34 2022
-- For Creating instances and LuaObjects.

----------------------------->> Services <<---------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local LocalPlayerScripts = if LocalPlayer then LocalPlayer.PlayerScripts else nil
local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))

----------------------------->> Library <<---------------------------------

local Library = {}
Library.Class = "InstanceLibrary"

function Library.New(Index, ...)
	assert(Index, "Missing Object ClassName.")
	assert(type(Index) == "string", "String Expected got: " .. typeof(Index))
	
	local function CheckDescendants(Object)
		for _,Child in pairs(Object:GetDescendants()) do
			if Child.Name == Index and Child:IsA("ModuleScript") then
				return Child
			end
		end
	end

	local Object = CheckDescendants(ReplicatedStorage.Luagame.LuaObjects)
	if not Object then 
		Object = CheckDescendants(ReplicatedStorage.Game.LuaObjects)
		if not Object then 
			if RunService:IsClient() then
				Object = CheckDescendants(LocalPlayerScripts["Clientside System"].LuaObjects)
				if not Object then
					Object = CheckDescendants(LocalPlayerScripts["Game"].LuaObjects)
				end
			else
				Object = CheckDescendants(ServerScriptService["Serverside System"].LuaObjects)
				if not Object then 
					Object = CheckDescendants(ServerScriptService.Game.LuaObjects)
				end
			end
		end
	end

	if Object then
		Object = require(Object)
		if rawget(Object, "new") then
			Object = Object.new(...)
		else
			Object = Object.bind(...)
		end
		return Object
	else
		error("Attempted to create missing object: '" .. Index .. "'")
	end
end

local Holder = Objectify(Library)
return Library