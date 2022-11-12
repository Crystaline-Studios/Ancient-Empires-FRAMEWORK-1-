local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")	
local Players = game:GetService("Players")

local LocalPlayerScripts = if Players.LocalPlayer then Players.LocalPlayer.PlayerScripts else nil
--[=[
	@class GET
]=]
--[=[
	@within GET
	@function GET
	Used Internally to get things.
	Read source code.

	@param Name string -- Name of the thing your trying to get
]=]
return function(Name: String)
	assert(Name, "Missing Value: Name(FIRST PARAMETER)")
	
	if Name == "Luagame" then
		return ReplicatedStorage.Game

	elseif Name == "GoodSignal" then
		return ReplicatedStorage.Game.LuaObjects.GoodSignal

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

	elseif Name == "ModerationService" then
		return ServerScriptService.Game.Services.ModerationService

	end
end
