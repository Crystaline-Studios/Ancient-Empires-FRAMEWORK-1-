-- Created By Carrotoplia on Tue Oct 11 16:18:47 2022
-- Quickzer made for quick easy scripting


----------------------------->> Services and modules <<---------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalPlayerScripts; if LocalPlayer then LocalPlayerScripts = LocalPlayer.PlayerScripts end

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local Luagame = require(Get("LuaService"))

----------------------------->> Variables <<---------------------------------

local IsClient = RunService:IsClient()
local Libraries = {}

local TrackedCoroutines = {}
local TrackedScriptData = {}


----------------------------->> Object <<---------------------------------


local Quick = {}
Quick.Class = "Engine"
Quick.class = Quick.Class



------------- Services Loader
-- Loads stuff in this order
-- default system
-- server/client services
-- replicated ones
-- it will override the oldest created services.

-- This allows for quick usage of services that are built in INSIDE services and stuff.
Luagame:CreateFromFolder(script.System.Services)
if IsClient then
	-- Client
	Luagame:CreateFromFolder(LocalPlayerScripts:WaitForChild("Clientside System").Services)
	Luagame:CreateFromFolder(LocalPlayerScripts.Game.Services)
else
	-- Server
	Luagame:CreateFromFolder(ServerScriptService:WaitForChild("Serverside System").Services)
	Luagame:CreateFromFolder(ServerScriptService.Game.Services)
end
Luagame:CreateFromFolder(ReplicatedStorage.Game.Services)




---------- Libraries Loader
for _,Library in pairs(script.System.Libraries:GetChildren()) do
	Libraries[Library.Name] = require(Library)
end
if IsClient then
	for _,Library in pairs(LocalPlayerScripts["Clientside System"].Libraries:GetChildren()) do
		Libraries[Library.Name] = require(Library)
	end
else
	for _,Library in pairs(ServerScriptService["Serverside System"].Libraries:GetChildren()) do
		Libraries[Library.Name] = require(Library)
	end
end


---------- Script State Control




function Quick:Track(Script, Yield)
	local Tab = {Coroutine = coroutine.running(), Value = true}
	TrackedCoroutines[Script] = Tab
	
	if Yield then
		coroutine.yield()
	end

	return Tab
end
Quick.track = Quick.Track







function Quick:Yield(Script)
	assert(Script, "Missing Parameter: Script")
	
	if not TrackedCoroutines[Script] then
		error("Attempted to yield a non captured script.")
	else
		TrackedCoroutines[Script].Value = false
		coroutine.yield(TrackedCoroutines[Script].Coroutine)
	end
	return TrackedScriptData[Script]
end
Quick.yield = Quick.Yield




function Quick:Release(Script, ...)
	assert(Script, "Missing Parameter: Script")

	if not TrackedCoroutines[Script] then
		error("Attempted to release a non captured script.")
	else
		TrackedCoroutines[Script].Value = true
		TrackedScriptData[Script] = ...
		coroutine.resume(TrackedCoroutines[Script].Coroutine)
	end 
end
Quick.release = Quick.Release







function Quick:YieldFolder(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetChildren()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Quick:Yield(Child)
		end
	end
end

function Quick:ReleaseFolder(Folder, ...)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetChildren()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Quick:Release(Child, ...)
		end
	end
end
Quick.releasefolder = Quick.ReleaseFolder
Quick.releaseFolder = Quick.ReleaseFolder





function Quick:YieldFolderDeep(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetDescendants()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Quick:Yield(Child)
		end
	end
end
Quick.yieldfolderdeep = Quick.YieldFolderDeep
Quick.yieldFolderDeep = Quick.YieldFolderDeep



function Quick:ReleaseFolderDeep(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetDescendants()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Quick:Release(Child)
		end
	end
end
Quick.releasefolderdeep = Quick.ReleaseFolderDeep
Quick.releaseFolderDeep = Quick.ReleaseFolderDeep


---------- Short Functions
function Quick:Luagame()
	return Luagame
end
Quick.luagame = Quick.Luagame
Quick.luaGame = Quick.Luagame
Quick.LuaGame = Quick.Luagame

function Quick:GetLibraries()
	return Libraries
end
Quick.getlibraries = Quick.GetLibraries
Quick.getLibraries = Quick.GetLibraries

local Holder = Objectify(Quick)
return Quick