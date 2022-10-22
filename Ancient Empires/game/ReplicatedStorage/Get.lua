--Created By Carrotoplia on Tue Oct 11 16:18:25 2022
-- Apart of the Quickzer Framework.
-- Used to get module scripts in replicated storage serverstorage sever code whatevr and starter pllayer

----------------------------->> Services <<---------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")	
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalPlayerScripts; if LocalPlayer then LocalPlayerScripts = LocalPlayer.PlayerScripts end

----------------------------->> Logic <<---------------------------------

return function(Name: String, Parent: String)
	assert(Name, "Missing Value: Name(FIRST PARAMETER)")
	local Prefind = {
		Quickzer = ReplicatedStorage.Quickzer,
		Objectify = ReplicatedStorage.Quickzer.System.Objectify
	}
	
	local function Check(Object)
		for _,Child in pairs(Object:GetDescendants()) do
			if Child.Name == Name and Child:IsA("ModuleScript") then
				if Child.Parent.Name == Parent and Parent or not Parent then
					return Child
				end
			end
		end
	end
	
	if Prefind[Name] then 
		return Prefind[Name]
	else
		local Result = Check(ReplicatedStorage)
		if not Result then
			if RunService:IsServer() then
				Result = Check(ServerScriptService)
				if not Result then
					Result = Check(ServerStorage)
				end
			else
				Result = Check(LocalPlayerScripts)
			end
		end
		return Result
	end
end
