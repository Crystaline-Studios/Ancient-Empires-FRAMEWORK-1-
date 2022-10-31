-- Created By Carrotoplia on Tue Oct 11 16:18:25 2022
-- Used to get module scripts quickly DO NOT USE THIS OUTSIDE OF THE SYSTEM

----------------------------->> Services <<---------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")	
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local LocalPlayerScripts = if LocalPlayer then LocalPlayer.PlayerScripts else nil

----------------------------->> Logic <<---------------------------------

return function(Name: String)
	assert(Name, "Missing Value: Name(FIRST PARAMETER)")
	
	if Name == "Luagame" then
		return ReplicatedStorage.Luagame
	elseif Name == "QuickSignal" then
		return ReplicatedStorage.Luagame.LuaObjects.QuickSignal
	elseif Name == "Objectify" then
		return ReplicatedStorage.Luagame.Objectify
	elseif Name == "Table" then
		return ReplicatedStorage.Luagame.Libraries.Table	
	elseif Name == "table" then
		return ReplicatedStorage.Luagame.Libraries.Table
	end
end
