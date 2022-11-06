-- Created By Carrotoplia on Tue Oct 11 16:18:25 2022
-- Used to get module scripts quickly DO NOT USE THIS OUTSIDE OF THE SYSTEM

----------------------------->> Services <<---------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")	
local Players = game:GetService("Players")

local LocalPlayerScripts = if Players.LocalPlayer then Players.LocalPlayer.PlayerScripts else nil

----------------------------->> Logic <<---------------------------------

return function(Name: String)
	assert(Name, "Missing Value: Name(FIRST PARAMETER)")
	
	if Name == "Luagame" then
		return ReplicatedStorage.Game
	elseif Name == "QuickSignal" then
		return ReplicatedStorage.Game.LuaObjects.QuickSignal
	elseif Name == "Table" then
		return ReplicatedStorage.Game.Libraries.Table	
	elseif Name == "table" then
		return ReplicatedStorage.Game.Libraries.Table
	elseif Name == "SConfig" then
		return ServerScriptService.Game.ServerConfig
	elseif Name == "RConfig" then
		return ReplicatedStorage.Game.ServerConfig
	elseif Name == "CConfig" then
		return LocalPlayerScripts.Game.ServerConfig
	end
end
